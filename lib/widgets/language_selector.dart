import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:culture_app/providers/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelector extends ConsumerWidget {
  final List<String> _languages = ['en', 'de'];
  final Map<String, String> languageMappings = {
    'en': 'English',
    'de': 'Deutsch',
  };
  LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(AppLocalizations.of(context)!.language),
      subtitle: Text(languageMappings[settings.language]!),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.selectLanguage),
            content: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: _languages.map((language) {
                  return RadioListTile<String>(
                    title: Text(languageMappings[language]!),
                    value: language,
                    groupValue: settings.language,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).setLanguage(value!);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
