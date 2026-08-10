#!/usr/bin/env python3
"""Extract individual decoration sprites from black/transparent sprite sheets."""

############################################################################
# Script is here for cut decoration images into small png.
############################################################################

from __future__ import annotations

import argparse
import re
from collections import defaultdict, deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter


DEFAULT_INPUT_DIR = Path("assets/image")
DEFAULT_OUTPUT_DIR = Path("assets/decorations")

DEFAULT_SKIP_STEMS = {
    "background",
    "loading",
    "name_logo",
}

CATEGORY_ALIASES = {
    "leaf": "leaf",
    "leaves": "leaf",
    "flower": "flower",
    "flowers": "flower",
    "mushroom": "mushroom",
    "mushrooms": "mushroom",
    "character": "character",
    "disappointed": "character",
    "don_t_go": "character",
    "dont_go": "character",
    "don't_go": "character",
    "mad": "character",
    "sad": "character",
    "shock": "character",
    "yay": "character",
}


############################################################################
# This function read command option from terminal.
############################################################################
def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Detect separate sprites on black/transparent sprite sheets, remove "
            "the background, crop each sprite, and save transparent PNGs."
        )
    )
    parser.add_argument("--input-dir", type=Path, default=DEFAULT_INPUT_DIR)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument(
        "--min-area",
        type=int,
        default=900,
        help="Ignore connected foreground regions smaller than this many pixels.",
    )
    parser.add_argument(
        "--alpha-threshold",
        type=int,
        default=8,
        help="Pixels with alpha above this are considered foreground on transparent sheets.",
    )
    parser.add_argument(
        "--background-threshold",
        type=float,
        default=32.0,
        help="Maximum RGB distance from the detected background color to treat as background.",
    )
    parser.add_argument(
        "--dark-background-max",
        type=int,
        default=48,
        help="Opaque sheets are processed only when the sampled border background is this dark.",
    )
    parser.add_argument(
        "--group-gap",
        type=int,
        default=5,
        help="Bridge foreground parts separated by up to this many pixels before labeling objects.",
    )
    parser.add_argument(
        "--padding",
        type=int,
        default=2,
        help="Transparent padding to keep around each cropped decoration.",
    )
    parser.add_argument(
        "--skip",
        nargs="*",
        default=sorted(DEFAULT_SKIP_STEMS),
        help="Case-insensitive image stems to skip by default.",
    )
    parser.add_argument(
        "--clear-output",
        action="store_true",
        help="Delete existing PNG files in the output folder before writing new sprites.",
    )
    return parser.parse_args()


############################################################################
# This function make file name simple.
############################################################################
def normalized_stem(path: Path) -> str:
    return re.sub(r"[^a-z0-9]+", "_", path.stem.lower()).strip("_")


############################################################################
# This function choose decoration group name.
############################################################################
def category_for(path: Path) -> str:
    stem = normalized_stem(path)
    if stem in CATEGORY_ALIASES:
        return CATEGORY_ALIASES[stem]
    if stem.endswith("s") and len(stem) > 1:
        stem = stem[:-1]
    return stem or "decoration"


############################################################################
# This function get image edge pixels.
############################################################################
def border_pixels(rgb: np.ndarray, alpha: np.ndarray, width: int = 8) -> tuple[np.ndarray, np.ndarray]:
    top = rgb[:width, :, :].reshape(-1, 3)
    bottom = rgb[-width:, :, :].reshape(-1, 3)
    left = rgb[:, :width, :].reshape(-1, 3)
    right = rgb[:, -width:, :].reshape(-1, 3)
    rgb_border = np.concatenate([top, bottom, left, right], axis=0)

    at = alpha[:width, :].reshape(-1)
    ab = alpha[-width:, :].reshape(-1)
    al = alpha[:, :width].reshape(-1)
    ar = alpha[:, -width:].reshape(-1)
    alpha_border = np.concatenate([at, ab, al, ar], axis=0)
    return rgb_border, alpha_border


############################################################################
# This function find which pixels is sprite.
############################################################################
def foreground_mask(
    image: Image.Image,
    alpha_threshold: int,
    background_threshold: float,
    dark_background_max: int,
) -> tuple[np.ndarray, np.ndarray]:
    rgba = np.asarray(image.convert("RGBA"))
    rgb = rgba[:, :, :3].astype(np.int16)
    alpha = rgba[:, :, 3]

    rgb_border, alpha_border = border_pixels(rgb, alpha)
    transparent_border_ratio = float(np.mean(alpha_border <= alpha_threshold))

    transparent_image_ratio = float(np.mean(alpha <= alpha_threshold))
    if transparent_border_ratio > 0.5 or transparent_image_ratio > 0.05:
        return alpha > alpha_threshold, rgba

    background = np.median(rgb_border, axis=0)
    if int(background.max()) > dark_background_max:
        return np.zeros(alpha.shape, dtype=bool), rgba

    distance = np.linalg.norm(rgb - background, axis=2)
    background_like = distance <= background_threshold
    background_connected = flood_fill_background(background_like)
    return ~background_connected, rgba


############################################################################
# This function mark background from image edge.
############################################################################
def flood_fill_background(background_like: np.ndarray) -> np.ndarray:
    height, width = background_like.shape
    seen = np.zeros_like(background_like, dtype=bool)
    queue: deque[tuple[int, int]] = deque()

    def add_if_background(y: int, x: int) -> None:
        if background_like[y, x] and not seen[y, x]:
            seen[y, x] = True
            queue.append((y, x))

    for x in range(width):
        add_if_background(0, x)
        add_if_background(height - 1, x)
    for y in range(height):
        add_if_background(y, 0)
        add_if_background(y, width - 1)

    while queue:
        y, x = queue.popleft()
        for ny, nx in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if 0 <= ny < height and 0 <= nx < width:
                add_if_background(ny, nx)
    return seen


############################################################################
# This function make mask bigger to connect pieces.
############################################################################
def dilate_mask(mask: np.ndarray, radius: int) -> np.ndarray:
    if radius <= 0:
        return mask
    size = radius * 2 + 1
    image = Image.fromarray((mask.astype(np.uint8) * 255), mode="L")
    return np.asarray(image.filter(ImageFilter.MaxFilter(size=size))) > 0


############################################################################
# This function find each separate sprite part.
############################################################################
def connected_components(mask: np.ndarray) -> tuple[np.ndarray, list[tuple[int, int, int, int, int, int]]]:
    height, width = mask.shape
    seen = np.zeros_like(mask, dtype=bool)
    labels = np.zeros(mask.shape, dtype=np.int32)
    components: list[tuple[int, int, int, int, int, int]] = []
    label = 0

    for start_y, start_x in zip(*np.nonzero(mask & ~seen)):
        if seen[start_y, start_x]:
            continue

        label += 1
        stack = [(int(start_y), int(start_x))]
        seen[start_y, start_x] = True
        labels[start_y, start_x] = label
        min_x = max_x = int(start_x)
        min_y = max_y = int(start_y)
        area = 0

        while stack:
            y, x = stack.pop()
            area += 1
            min_x = min(min_x, x)
            max_x = max(max_x, x)
            min_y = min(min_y, y)
            max_y = max(max_y, y)

            for ny in (y - 1, y, y + 1):
                for nx in (x - 1, x, x + 1):
                    if ny == y and nx == x:
                        continue
                    if 0 <= ny < height and 0 <= nx < width and mask[ny, nx] and not seen[ny, nx]:
                        seen[ny, nx] = True
                        labels[ny, nx] = label
                        stack.append((ny, nx))

        components.append((min_x, min_y, max_x + 1, max_y + 1, area, label))

    components.sort(key=lambda box: (box[1], box[0]))
    return labels, components


############################################################################
# This function crop one sprite and make outside transparent.
############################################################################
def crop_component(
    rgba: np.ndarray,
    original_mask: np.ndarray,
    labels: np.ndarray,
    grouped_box: tuple[int, int, int, int, int, int],
    padding: int,
) -> Image.Image | None:
    height, width = original_mask.shape
    gx0, gy0, gx1, gy1, _, label = grouped_box
    component_mask = labels[gy0:gy1, gx0:gx1] == label
    region_mask = original_mask[gy0:gy1, gx0:gx1] & component_mask
    if not region_mask.any():
        return None

    ys, xs = np.nonzero(region_mask)
    x0 = max(gx0 + int(xs.min()) - padding, 0)
    y0 = max(gy0 + int(ys.min()) - padding, 0)
    x1 = min(gx0 + int(xs.max()) + 1 + padding, width)
    y1 = min(gy0 + int(ys.max()) + 1 + padding, height)

    cropped = rgba[y0:y1, x0:x1, :].copy()
    crop_mask = original_mask[y0:y1, x0:x1] & (labels[y0:y1, x0:x1] == label)
    cropped[:, :, 3] = np.where(crop_mask, cropped[:, :, 3], 0).astype(np.uint8)
    cropped[:, :, 3] = np.where(crop_mask & (cropped[:, :, 3] == 0), 255, cropped[:, :, 3]).astype(np.uint8)
    return Image.fromarray(cropped, mode="RGBA")


############################################################################
# This function extract all sprite in one sheet.
############################################################################
def extract_sheet(
    source: Path,
    output_dir: Path,
    counts: defaultdict[str, int],
    args: argparse.Namespace,
) -> int:
    image = Image.open(source).convert("RGBA")
    mask, rgba = foreground_mask(
        image,
        alpha_threshold=args.alpha_threshold,
        background_threshold=args.background_threshold,
        dark_background_max=args.dark_background_max,
    )
    if not mask.any():
        print(f"skip {source.name}: no transparent or black sprite background detected")
        return 0

    grouped_mask = dilate_mask(mask, args.group_gap)
    labels, all_components = connected_components(grouped_mask)
    components = [box for box in all_components if box[4] >= args.min_area]
    category = category_for(source)
    written = 0

    for component in components:
        sprite = crop_component(rgba, mask, labels, component, args.padding)
        if sprite is None:
            continue
        counts[category] += 1
        output_path = output_dir / f"{category}_{counts[category]:02d}.png"
        sprite.save(output_path)
        written += 1

    print(f"{source.name}: wrote {written} sprite(s)")
    return written


############################################################################
# Main script run is here.
############################################################################
def main() -> None:
    args = parse_args()
    output_dir = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    if args.clear_output:
        for png in output_dir.glob("*.png"):
            png.unlink()

    skip = {re.sub(r"[^a-z0-9]+", "_", item.lower()).strip("_") for item in args.skip}
    sources = [
        path
        for path in sorted(args.input_dir.glob("*.png"))
        if normalized_stem(path) not in skip
    ]

    counts: defaultdict[str, int] = defaultdict(int)
    total = 0
    for source in sources:
        total += extract_sheet(source, output_dir, counts, args)

    print(f"done: wrote {total} sprite(s) to {output_dir}")


if __name__ == "__main__":
    main()
