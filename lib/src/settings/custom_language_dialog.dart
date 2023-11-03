import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/settings.dart';
import '../settings/settings.dart';

void showLanguageSelectionDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) =>
        LanguageSelectionDialog(animation: animation),
  );
}

class LanguageSelectionDialog extends StatefulWidget {
  final Animation<double> animation;

  const LanguageSelectionDialog({required this.animation, Key? key})
      : super(key: key);

  @override
  State<LanguageSelectionDialog> createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: widget.animation,
        curve: Curves.easeOutCubic,
      ),
      child: SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Select Language'),
          ],
        ),
        children: [
          const _LanguageOption("English"),
          const _LanguageOption("Polski"),
          const _LanguageOption("Deutsch"),
          // TODO Add more language options here as needed
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;

  const _LanguageOption(this.language);

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsController>();

    return InkWell(
      onTap: () {
        if (language == "English") {
          settings.setAppLanguage(AppLanguage.english);
        } else if (language == "Polski") {
          settings.setAppLanguage(AppLanguage.polish);
        } else if (language == "Deutsch") {
          settings.setAppLanguage(AppLanguage.german);
        }
        // Implement setting language logic for other languages
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          language,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
