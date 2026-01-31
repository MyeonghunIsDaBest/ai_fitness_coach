import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/sport.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/athlete_profile.dart';

/// ProfileScreen - User profile and settings screen (Semi-dark theme)
/// Features:
/// - Profile header with gradient avatar
/// - Lifetime stats summary
/// - Menu sections for training, profile, settings, and support
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);
  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentBlue = Color(0xFF3B82F6);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _accentCyan = Color(0xFF00D9FF);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _achievementGold = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentAthleteProfileProvider);
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(100));

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: _accentGreen,
          backgroundColor: _cardColor,
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    'Profile',
                    style: TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildProfileHeader(context, ref, profileAsync),
                _buildStatsSummary(totalWorkoutsAsync, workoutHistoryAsync),
                const SizedBox(height: 24),
                _buildMenuSection(
                  context,
                  title: 'Training',
                  items: [
                    _MenuItem(icon: Icons.fitness_center, iconColor: _accentGreen, title: 'Training Preferences', subtitle: 'Rest times, units, RPE scale', onTap: () => context.push('/settings')),
                    _MenuItem(icon: Icons.history, iconColor: _accentCyan, title: 'Workout History', subtitle: 'View all past workouts', onTap: () => context.push('/history')),
                    _MenuItem(icon: Icons.emoji_events, iconColor: _achievementGold, title: 'Personal Records', subtitle: 'View your PRs', onTap: () {}),
                  ],
                ),
                _buildMenuSection(
                  context,
                  title: 'Profile',
                  items: [
                    _MenuItem(icon: Icons.person_outline, iconColor: const Color(0xFFE879F9), title: 'Edit Profile', subtitle: 'Name, bodyweight, experience level', onTap: () => _showEditProfileSheet(context, ref, profileAsync.valueOrNull)),
                    _MenuItem(icon: Icons.monitor_weight_outlined, iconColor: const Color(0xFFF97316), title: 'Max Lifts', subtitle: 'Update your 1RM values', onTap: () {}),
                    _MenuItem(icon: Icons.healing, iconColor: const Color(0xFFEF4444), title: 'Injuries & Limitations', subtitle: 'Manage restrictions', onTap: () {}),
                  ],
                ),
                _buildMenuSection(
                  context,
                  title: 'App Settings',
                  items: [
                    _MenuItem(icon: Icons.settings_outlined, iconColor: _textSecondary, title: 'Settings', subtitle: 'Theme, units, notifications', onTap: () => context.push('/settings')),
                  ],
                ),
                _buildMenuSection(
                  context,
                  title: 'Support',
                  items: [
                    _MenuItem(icon: Icons.help_outline, iconColor: _accentCyan, title: 'Help & FAQ', onTap: () {}),
                    _MenuItem(icon: Icons.feedback_outlined, iconColor: _accentGreen, title: 'Send Feedback', onTap: () {}),
                    _MenuItem(icon: Icons.info_outline, iconColor: _textSecondary, title: 'About', subtitle: 'Version 1.0.0', onTap: () {}),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, WidgetRef ref, AsyncValue<AthleteProfile?> profileAsync) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accentBlue.withOpacity(0.15), _cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accentBlue.withOpacity(0.3)),
      ),
      child: profileAsync.when(
        data: (profile) {
          final name = profile?.name ?? 'Athlete';
          final sport = profile?.sport.name ?? 'General Fitness';
          final experience = profile?.experienceLevel.name ?? 'Beginner';
          final bodyweight = profile?.bodyweight;

          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [_accentBlue, _accentCyan], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(color: _cardColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'A',
                      style: const TextStyle(color: _accentBlue, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: _textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(_capitalizeFirst(experience), style: const TextStyle(color: _accentBlue, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip(icon: Icons.sports, label: _capitalizeFirst(sport)),
                        if (bodyweight != null) ...[
                          const SizedBox(width: 10),
                          _buildInfoChip(icon: Icons.monitor_weight_outlined, label: '${bodyweight.toStringAsFixed(0)} kg'),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _accentBlue.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.edit_outlined, color: _accentBlue, size: 20),
                ),
                onPressed: () => _showEditProfileSheet(context, ref, profile),
              ),
            ],
          );
        },
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: _accentGreen))),
        error: (_, __) => _buildDefaultProfileHeader(context, ref),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _textSecondary, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDefaultProfileHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [_accentBlue, _accentCyan])),
          child: Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(color: _cardColor, shape: BoxShape.circle),
            child: const Icon(Icons.person, size: 36, color: _accentBlue),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome', style: TextStyle(color: _textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Set up your profile to get started', style: TextStyle(color: _textSecondary, fontSize: 14)),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => _showEditProfileSheet(context, ref, null),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: _accentGreen, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Setup Profile', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(AsyncValue<int> totalWorkoutsAsync, AsyncValue<List<dynamic>> workoutHistoryAsync) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    double totalVolume = 0;
    for (final session in sessions) {
      if (session.sets != null) {
        for (final set in session.sets) {
          totalVolume += (set.weight ?? 0) * (set.reps ?? 0);
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _accentCyan.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.bar_chart_rounded, color: _accentCyan, size: 22),
              ),
              const SizedBox(width: 14),
              const Text('Lifetime Stats', style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Workouts',
                  value: totalWorkoutsAsync.when(data: (count) => count.toString(), loading: () => '-', error: (_, __) => '0'),
                  icon: Icons.fitness_center,
                  color: _accentGreen,
                ),
              ),
              Container(width: 1, height: 56, color: _cardColorLight.withOpacity(0.5)),
              Expanded(
                child: _StatItem(
                  label: 'Total Volume',
                  value: _formatVolume(totalVolume),
                  icon: Icons.trending_up,
                  color: _accentCyan,
                ),
              ),
              Container(width: 1, height: 56, color: _cardColorLight.withOpacity(0.5)),
              const Expanded(
                child: _StatItem(label: 'PRs Set', value: '-', icon: Icons.emoji_events, color: _achievementGold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) return '${(volume / 1000000).toStringAsFixed(1)}M';
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}k';
    return volume.toStringAsFixed(0);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _buildMenuSection(BuildContext context, {required String title, required List<_MenuItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(title.toUpperCase(), style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item.onTap,
                        borderRadius: BorderRadius.vertical(
                          top: index == 0 ? const Radius.circular(20) : Radius.zero,
                          bottom: isLast ? const Radius.circular(20) : Radius.zero,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: item.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                                child: Icon(item.icon, color: item.iconColor, size: 22),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                                    if (item.subtitle != null) ...[
                                      const SizedBox(height: 4),
                                      Text(item.subtitle!, style: const TextStyle(color: _textSecondary, fontSize: 13)),
                                    ],
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: _textSecondary, size: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isLast) Container(margin: const EdgeInsets.only(left: 68), height: 1, color: _cardColorLight.withOpacity(0.3)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, AthleteProfile? currentProfile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
  final IconData icon;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: const Color(0xFFE2E8F0).withOpacity(0.6), fontSize: 12)),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _MenuItem({required this.icon, required this.iconColor, required this.title, this.subtitle, this.onTap});
}

class EditProfileSheet extends StatefulWidget {
  final AthleteProfile? currentProfile;
  final Future<void> Function(AthleteProfile) onSave;

  const EditProfileSheet({super.key, this.currentProfile, required this.onSave});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _bodyweightController;
  bool _isSaving = false;

  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _backgroundColor = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentProfile?.name ?? '');
    _bodyweightController = TextEditingController(text: widget.currentProfile?.bodyweight?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bodyweightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: _cardColor, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: _cardColorLight, borderRadius: BorderRadius.circular(3)))),
          const SizedBox(height: 24),
          const Text('Edit Profile', style: TextStyle(color: _textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          _buildTextField(controller: _nameController, label: 'Name', icon: Icons.person_outline),
          const SizedBox(height: 18),
          _buildTextField(controller: _bodyweightController, label: 'Bodyweight (kg)', icon: Icons.monitor_weight_outlined, keyboardType: TextInputType.number),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: _accentGreen.withOpacity(0.5),
              ),
              child: _isSaving
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textSecondary),
        prefixIcon: Icon(icon, color: _textSecondary, size: 22),
        filled: true,
        fillColor: _backgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _cardColorLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _cardColorLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _accentGreen, width: 2)),
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
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: _accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFEF4444)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
