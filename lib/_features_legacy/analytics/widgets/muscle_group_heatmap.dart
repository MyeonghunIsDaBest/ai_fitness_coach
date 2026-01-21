// lib/features/analytics/widgets/muscle_group_heatmap.dart

import 'package:flutter/material.dart';
import '../../../domain/models/chart_data.dart';
import '../../../core/enums/lift_type.dart';

class MuscleGroupHeatmap extends StatelessWidget {
  final List<MuscleGroupData> data;

  const MuscleGroupHeatmap({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: Text(
          'No muscle group data available',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      );
    }

    // Sort by RPE descending
    final sortedData = List<MuscleGroupData>.from(data)
      ..sort((a, b) => b.averageRPE.compareTo(a.averageRPE));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Muscle Group Fatigue Map',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Showing average RPE by muscle group',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 20),
          _buildHeatmap(sortedData),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatmap(List<MuscleGroupData> sortedData) {
    return Column(
      children: sortedData.map((muscleData) {
        return _buildMuscleRow(muscleData);
      }).toList(),
    );
  }

  Widget _buildMuscleRow(MuscleGroupData muscleData) {
    final intensity = _getIntensity(muscleData.averageRPE);
    final color = _getColorForRPE(muscleData.averageRPE);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Muscle name and RPE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                muscleData.muscleGroup.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    muscleData.averageRPE.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${muscleData.totalSets} sets)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Heat bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color,
                  ],
                  stops: [0.0, intensity],
                ),
                border: Border.all(
                  color: color.withOpacity(0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Fill based on intensity
                  FractionallySizedBox(
                    widthFactor: intensity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Intensity label
                  Center(
                    child: Text(
                      _getIntensityLabel(muscleData.averageRPE),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: intensity > 0.5 ? Colors.white : color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Exercises
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: muscleData.exercises.take(3).map((exercise) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exercise,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RPE Scale',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Low', const Color(0xFF4ECDC4), '6-7'),
              _buildLegendItem('Moderate', const Color(0xFFB4F04D), '7-8'),
              _buildLegendItem('High', const Color(0xFFFFE66D), '8-9'),
              _buildLegendItem('Very High', const Color(0xFFFF6B6B), '9-10'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  double _getIntensity(double rpe) {
    // Map RPE (6-10) to intensity (0-1)
    return ((rpe - 6.0) / 4.0).clamp(0.0, 1.0);
  }

  Color _getColorForRPE(double rpe) {
    if (rpe < 7.0) return const Color(0xFF4ECDC4); // Blue
    if (rpe < 8.0) return const Color(0xFFB4F04D); // Green
    if (rpe < 9.0) return const Color(0xFFFFE66D); // Yellow
    return const Color(0xFFFF6B6B); // Red
  }

  String _getIntensityLabel(double rpe) {
    if (rpe < 7.0) return 'LOW';
    if (rpe < 8.0) return 'MODERATE';
    if (rpe < 9.0) return 'HIGH';
    return 'VERY HIGH';
  }
}
