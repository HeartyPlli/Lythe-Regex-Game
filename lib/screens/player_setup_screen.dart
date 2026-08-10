part of '../main.dart';

//=========================================================================
// Ui player setup is here for name and avatar choose.
//=========================================================================
class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({
    required this.onBack,
    required this.onConfirm,
    super.key,
  });

  final VoidCallback onBack;
  final void Function(String username, String avatar) onConfirm;

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

//=========================================================================
// This class is about _PlayerSetupScreenState thing.
//=========================================================================
class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _selectedAvatar = _characterChoices.first;
  String? _error;

  static const List<String> _characterChoices = [
    'character_01.png',
    'character_02.png',
    'character_03.png',
    'character_04.png',
    'character_05.png',
    'character_06.png',
    'character_07.png',
    'character_08.png',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _confirm() {
    final username = _usernameController.text.trim();
    if (username.length < 3) {
      setState(() => _error = 'Please enter at least 3 characters.');
      return;
    }
    widget.onConfirm(username, _selectedAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              HeaderRibbon(title: 'PLAYER SETUP', onBack: widget.onBack),
              CutePanel(
                decoration: PanelDecoration.character,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      PinkLabel(text: 'Enter your username:'),
                      TextField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _confirm(),
                        decoration: InputDecoration(
                          hintText: 'Type your player name...',
                          errorText: _error,
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.9),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.brown.withValues(alpha: 0.45),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.pink,
                              width: 3,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'SELECT CHARACTER',
                        style: TextStyle(
                          color: AppColors.brown,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final avatar in _characterChoices)
                            CharacterChoice(
                              avatar: avatar,
                              selected: avatar == _selectedAvatar,
                              onTap: () =>
                                  setState(() => _selectedAvatar = avatar),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CuteGameButton(
                        label: 'START GAME',
                        icon: Icons.play_arrow_rounded,
                        onPressed: _confirm,
                        green: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//=========================================================================
// This class is about CharacterChoice thing.
//=========================================================================
class CharacterChoice extends StatelessWidget {
  const CharacterChoice({
    required this.avatar,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String avatar;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.08 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: 86,
          height: 86,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? AppColors.palePink : AppColors.cream,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.pink : AppColors.peachStroke,
              width: selected ? 3 : 2,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.22),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
            ],
          ),
          child: Image.asset('assets/decorations/$avatar', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
