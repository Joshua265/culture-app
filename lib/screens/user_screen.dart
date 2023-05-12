import 'package:culture_app/providers/settings_provider.dart';
import 'package:culture_app/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Personal Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.confirmation_num),
                  title: const Text('My Tickets'),
                  onTap: () {
                    // TODO: navigate to tickets screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('City'),
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
              'Display Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
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
              'Account Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: () {
                    // TODO: navigate to password change screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Edit Payment Methods'),
                  onTap: () {
                    // TODO: navigate to payment methods screen
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
