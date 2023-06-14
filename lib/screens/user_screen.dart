import 'package:culture_app/providers/settings_provider.dart';
import 'package:culture_app/screens/ticket_screen.dart';
import 'package:culture_app/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.user),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.personalSettings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.confirmation_num),
                      title: Text(AppLocalizations.of(context)!.myTickets),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TicketsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(AppLocalizations.of(context)!.city),
                      subtitle: Text(settings.city),
                      onTap: () {
                        // TODO: navigate to location settings screen
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.displaySettings,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.darkMode),
                      value: settings.darkMode,
                      onChanged: (bool value) {
                        ref.read(settingsProvider.notifier).toggleDarkMode();
                      },
                    ),
                    LanguageSelector(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.accountSettings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(AppLocalizations.of(context)!.changePassword),
                      onTap: () {
                        // TODO: navigate to password change screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(
                          AppLocalizations.of(context)!.editPaymentMethods),
                      onTap: () {
                        // TODO: navigate to payment methods screen
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
