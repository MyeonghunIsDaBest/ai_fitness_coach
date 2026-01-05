import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';
import '../../domain/models/athlete_profile.dart';

class GoalSetupScreen extends StatefulWidget {
  final Sport? selectedSport;

  const GoalSetupScreen({Key? key, this.selectedSport}) : super(key: key);

  @override
  State<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  ExperienceLevel _experienceLevel = ExperienceLevel.beginner;
  BodyweightUnit _weightUnit = BodyweightUnit.kg;
  TrainingGoal _primaryGoal = TrainingGoal.buildStrength;
  int _workoutDaysPerWeek = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = AthleteProfile.create(
        name: _nameController.text,
        sport: widget.selectedSport ?? Sport.generalFitness,
        experienceLevel: _experienceLevel,
        bodyweight: double.parse(_weightController.text),
        bodyweightUnit: _weightUnit,
        preferredWorkoutDays: _workoutDaysPerWeek,
        primaryGoal: _primaryGoal,
      );

      // TODO: Save profile using repository

      Navigator.pushReplacementNamed(context, '/program-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Let\'s personalize your training',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll use this to create your perfect program',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Name Input
                _buildSectionTitle('What\'s your name?'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Experience Level
                _buildSectionTitle('Training Experience'),
                const SizedBox(height: 12),
                ...ExperienceLevel.values.map(
                  (level) => _buildRadioOption<ExperienceLevel>(
                    value: level,
                    groupValue: _experienceLevel,
                    title: level.displayName,
                    subtitle: level.description,
                    onChanged: (value) {
                      setState(() => _experienceLevel = value!);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Body Weight
                _buildSectionTitle('Current Body Weight'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Weight',
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<BodyweightUnit>(
                        value: _weightUnit,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: BodyweightUnit.values.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit.symbol),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _weightUnit = value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Primary Goal
                _buildSectionTitle('Primary Training Goal'),
                const SizedBox(height: 12),
                ...TrainingGoal.values.map(
                  (goal) => _buildRadioOption<TrainingGoal>(
                    value: goal,
                    groupValue: _primaryGoal,
                    title: goal.displayName,
                    subtitle: goal.description,
                    onChanged: (value) {
                      setState(() => _primaryGoal = value!);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Workout Days
                _buildSectionTitle('Training Days Per Week'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    final days = index + 2; // 2-7 days
                    return _buildDayButton(days);
                  }),
                ),
                const SizedBox(height: 40),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue to Programs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRadioOption<T>({
    required T value,
    required T groupValue,
    required String title,
    required String subtitle,
    required ValueChanged<T?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFB4F04D).withOpacity(0.1)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? const Color(0xFFB4F04D) : Colors.white30,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.black)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white60 : Colors.white40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayButton(int days) {
    final isSelected = _workoutDaysPerWeek == days;
    return InkWell(
      onTap: () => setState(() => _workoutDaysPerWeek = days),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB4F04D) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '$days',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
