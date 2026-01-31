import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// SettingsScreen - App settings and preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Settings',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Training section
          _SectionHeader(
            title: 'Training',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _SettingsCard(
            colorScheme: colorScheme,
            children: [
              _SettingsTile(
                icon: Icons.fitness_center,
                title: 'Units',
                subtitle: 'Kilograms (kg)',
                onTap: () => _showUnitsDialog(context),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.timer_outlined,
                title: 'Default Rest Timer',
                subtitle: '2 minutes',
                onTap: () => _showRestTimerDialog(context),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.speed,
                title: 'RPE Scale',
                subtitle: '1-10 (Standard)',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Appearance section
          _SectionHeader(
            title: 'Appearance',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _SettingsCard(
            colorScheme: colorScheme,
            children: [
              _SettingsToggle(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // TODO: Implement theme switching
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Theme switching coming soon!')),
                  );
                },
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.text_fields,
                title: 'Text Size',
                subtitle: 'Medium',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notifications section
          _SectionHeader(
            title: 'Notifications',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _SettingsCard(
            colorScheme: colorScheme,
            children: [
              _SettingsToggle(
                icon: Icons.notifications_outlined,
                title: 'Workout Reminders',
                value: true,
                onChanged: (value) {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsToggle(
                icon: Icons.celebration_outlined,
                title: 'PR Notifications',
                value: true,
                onChanged: (value) {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.schedule,
                title: 'Reminder Time',
                subtitle: '6:00 PM',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data section
          _SectionHeader(
            title: 'Data',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _SettingsCard(
            colorScheme: colorScheme,
            children: [
              _SettingsTile(
                icon: Icons.download_outlined,
                title: 'Export Data',
                subtitle: 'Export workout history as CSV',
                onTap: () => _showExportDialog(context),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.backup_outlined,
                title: 'Backup',
                subtitle: 'Last backup: Never',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.delete_outline,
                title: 'Clear All Data',
                subtitle: 'Delete all workout history',
                onTap: () => _showClearDataDialog(context),
                colorScheme: colorScheme,
                textTheme: textTheme,
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About section
          _SectionHeader(
            title: 'About',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _SettingsCard(
            colorScheme: colorScheme,
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _Divider(colorScheme: colorScheme),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showUnitsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weight Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Kilograms (kg)'),
              leading: const Icon(Icons.check),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Pounds (lbs)'),
              leading: const Icon(Icons.radio_button_unchecked),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Rest Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mins in [1, 2, 3, 4, 5])
              ListTile(
                title: Text('$mins minute${mins > 1 ? 's' : ''}'),
                leading: Icon(mins == 2 ? Icons.check : Icons.radio_button_unchecked),
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export your workout history as a CSV file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your workout history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SectionHeader({
    required this.title,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final ColorScheme colorScheme;
  final List<Widget> children;

  const _SettingsCard({
    required this.colorScheme,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: color),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF3B82F6),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final ColorScheme colorScheme;

  const _Divider({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: colorScheme.outlineVariant,
    );
  }
}
