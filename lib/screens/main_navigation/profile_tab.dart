import 'package:flutter/material.dart';

/// Profile tab - user settings and information
class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                  const SizedBox(height: 24),
                  _buildDataSection(context),
                  const SizedBox(height: 24),
                  _buildAboutSection(context),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            // TODO: Edit profile
          },
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFB4F04D),
                        const Color(0xFFB4F04D).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB4F04D),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1E1E1E),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Powerlifter • Member since Jan 2026',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfileStat('48', 'Workouts'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white12,
                ),
                _buildProfileStat('12', 'Weeks'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white12,
                ),
                _buildProfileStat('2', 'Programs'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB4F04D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Records',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPRItem('Squat', '140 kg', '1RM', Icons.fitness_center),
                const Divider(height: 24, color: Colors.white12),
                _buildPRItem(
                    'Bench Press', '100 kg', '1RM', Icons.fitness_center),
                const Divider(height: 24, color: Colors.white12),
                _buildPRItem('Deadlift', '180 kg', '1RM', Icons.fitness_center),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPRItem(
      String exercise, String weight, String type, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFB4F04D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFB4F04D), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
        Text(
          weight,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB4F04D),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildSettingItem(
                context,
                Icons.person_outline,
                'Edit Profile',
                'Update your personal information',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.fitness_center,
                'Training Preferences',
                'Set your workout goals and preferences',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.notifications_outlined,
                'Notifications',
                'Manage workout reminders and alerts',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.scale_outlined,
                'Units',
                'Choose weight and measurement units',
                () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data & Privacy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildSettingItem(
                context,
                Icons.cloud_download_outlined,
                'Export Data',
                'Download your workout history',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.backup_outlined,
                'Backup & Sync',
                'Manage data backup and synchronization',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.delete_outline,
                'Clear Data',
                'Reset all workout data',
                () {},
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildSettingItem(
                context,
                Icons.help_outline,
                'Help & Support',
                'Get help with the app',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.article_outlined,
                'Privacy Policy',
                'Read our privacy policy',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.description_outlined,
                'Terms of Service',
                'Read our terms of service',
                () {},
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildSettingItem(
                context,
                Icons.info_outline,
                'About',
                'Version 1.0.0',
                () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () {
              // TODO: Sign out
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFFB4F04D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFFB4F04D),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDestructive ? Colors.red.withOpacity(0.7) : Colors.white60,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.white30,
      ),
      onTap: onTap,
    );
  }
}
