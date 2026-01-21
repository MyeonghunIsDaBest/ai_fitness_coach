import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/sport.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/athlete_profile.dart';
import '../../widgets/design_system/atoms/atoms.dart';

/// ProfileScreen - User profile and settings screen
///
/// Displays user information, statistics, and app settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch providers
    final profileAsync = ref.watch(currentAthleteProfileProvider);
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(100));

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentAthleteProfileProvider);
          ref.invalidate(totalWorkoutsProvider);
          ref.invalidate(workoutHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              _buildProfileHeader(colorScheme, textTheme, profileAsync),

              // Stats summary
              _buildStatsSummary(
                colorScheme,
                textTheme,
                totalWorkoutsAsync,
                workoutHistoryAsync,
              ),
              const SizedBox(height: 24),

              // Menu sections
              _buildMenuSection(
                context,
                colorScheme,
                textTheme,
                title: 'Training',
                items: [
                  _MenuItem(
                    icon: Icons.fitness_center,
                    title: 'Training Preferences',
                    subtitle: 'Rest times, units, RPE scale',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.history,
                    title: 'Workout History',
                    subtitle: 'View all past workouts',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.emoji_events,
                    title: 'Personal Records',
                    subtitle: 'View your PRs',
                    onTap: () {},
                  ),
                ],
              ),

              _buildMenuSection(
                context,
                colorScheme,
                textTheme,
                title: 'Profile',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Name, bodyweight, experience level',
                    onTap: () => _showEditProfileSheet(context, ref, profileAsync.valueOrNull),
                  ),
                  _MenuItem(
                    icon: Icons.monitor_weight_outlined,
                    title: 'Max Lifts',
                    subtitle: 'Update your 1RM values',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.healing,
                    title: 'Injuries & Limitations',
                    subtitle: 'Manage restrictions',
                    onTap: () {},
                  ),
                ],
              ),

              _buildMenuSection(
                context,
                colorScheme,
                textTheme,
                title: 'App Settings',
                items: [
                  _MenuItem(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Theme, colors',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Reminders, alerts',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.backup_outlined,
                    title: 'Backup & Sync',
                    subtitle: 'Data management',
                    onTap: () {},
                  ),
                ],
              ),

              _buildMenuSection(
                context,
                colorScheme,
                textTheme,
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.feedback_outlined,
                    title: 'Send Feedback',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign out button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton.secondary(
                  text: 'Sign Out',
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<AthleteProfile?> profileAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: profileAsync.when(
        data: (profile) {
          final name = profile?.name ?? 'Athlete';
          final sport = profile?.sport.name ?? 'General Fitness';
          final experience = profile?.experienceLevel.name ?? 'Beginner';
          final bodyweight = profile?.bodyweight;

          return Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'A',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$experience $sport',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (bodyweight != null)
                          AppBadge(
                            text: '${bodyweight.toStringAsFixed(0)} kg',
                            variant: AppBadgeVariant.neutral,
                            size: AppBadgeSize.small,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          );
        },
        loading: () => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        ),
        error: (_, __) => _buildDefaultProfileHeader(colorScheme, textTheme),
      ),
    );
  }

  Widget _buildDefaultProfileHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 40,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Set up your profile to get started',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<int> totalWorkoutsAsync,
    AsyncValue<List<dynamic>> workoutHistoryAsync,
  ) {
    // Calculate total volume from history
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    double totalVolume = 0;
    for (final session in sessions) {
      if (session.sets != null) {
        for (final set in session.sets) {
          totalVolume += (set.weight ?? 0) * (set.reps ?? 0);
        }
      }
    }

    String formatVolume(double volume) {
      if (volume >= 1000000) {
        return '${(volume / 1000000).toStringAsFixed(1)}M kg';
      } else if (volume >= 1000) {
        return '${(volume / 1000).toStringAsFixed(1)}k kg';
      }
      return '${volume.toStringAsFixed(0)} kg';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lifetime Stats',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Workouts',
                  value: totalWorkoutsAsync.when(
                    data: (count) => count.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _StatItem(
                  label: 'Total Volume',
                  value: formatVolume(totalVolume),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _StatItem(
                  label: 'PRs Set',
                  value: '-', // TODO: Track PRs
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(item.icon, color: colorScheme.onSurfaceVariant),
                      title: Text(
                        item.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: item.subtitle != null
                          ? Text(
                              item.subtitle!,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onTap: item.onTap,
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: colorScheme.outlineVariant,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    AthleteProfile? currentProfile,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProfileSheet(
        currentProfile: currentProfile,
        onSave: (profile) async {
          final saveProfile = ref.read(saveAthleteProfileProvider);
          await saveProfile(profile);
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatItem({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}

/// Bottom sheet for editing profile
class EditProfileSheet extends StatefulWidget {
  final AthleteProfile? currentProfile;
  final Future<void> Function(AthleteProfile) onSave;

  const EditProfileSheet({
    super.key,
    this.currentProfile,
    required this.onSave,
  });

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _bodyweightController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile?.name ?? '',
    );
    _bodyweightController = TextEditingController(
      text: widget.currentProfile?.bodyweight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bodyweightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Name field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Bodyweight field
          TextField(
            controller: _bodyweightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Bodyweight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final bodyweight = double.tryParse(_bodyweightController.text) ?? 70.0;

      final profile = widget.currentProfile?.copyWith(
            name: _nameController.text.trim(),
            bodyweight: bodyweight,
            updatedAt: DateTime.now(),
          ) ??
          AthleteProfile.create(
            name: _nameController.text.trim(),
            sport: Sport.generalFitness,
            experienceLevel: ExperienceLevel.beginner,
            bodyweight: bodyweight,
            bodyweightUnit: BodyweightUnit.kg,
            preferredWorkoutDays: 4,
            primaryGoal: TrainingGoal.buildStrength,
          );

      await widget.onSave(profile);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
