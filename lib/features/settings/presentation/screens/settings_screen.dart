import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SettingsSection(
              title: 'General',
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Change app appearance',
                  onTap: () {
                    // Handle theme settings
                  },
                ),
                _SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    // Handle notification settings
                  },
                ),
              ],
            ),
            SizedBox(height: Spacing.xl),
            _SettingsSection(
              title: 'Data & Privacy',
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.backup,
                  title: 'Backup & Sync',
                  subtitle: 'Manage your data backup',
                  onTap: () {
                    // Handle backup settings
                  },
                ),
                _SettingsTile(
                  icon: Icons.security,
                  title: 'Privacy',
                  subtitle: 'Control your privacy settings',
                  onTap: () {
                    // Handle privacy settings
                  },
                ),
              ],
            ),
            SizedBox(height: Spacing.xl),
            _SettingsSection(
              title: 'About',
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.info,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: null,
                ),
                _SettingsTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  onTap: () {
                    // Handle help
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Spacing.md),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
