import 'package:flutter/material.dart';
import '../../core/enums/rpe_feedback.dart';
import '../../core/utils/rpe_math.dart';

class RPEFeedbackWidget extends StatelessWidget {
  final double currentRPE;
  final double targetRPEMin;
  final double targetRPEMax;

  const RPEFeedbackWidget({
    Key? key,
    required this.currentRPE,
    required this.targetRPEMin,
    required this.targetRPEMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedback = RPEMath.getFeedback(currentRPE, targetRPEMin, targetRPEMax);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(feedback.colorValue).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(feedback.colorValue), width: 2),
      ),
      child: Row(
        children: [
          Icon(feedback.icon, color: Color(feedback.colorValue), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feedback.message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(RPEFeedback feedback) {
    switch (feedback) {
      case RPEFeedback.tooEasy:
        return Icons.sentiment_very_satisfied;
      case RPEFeedback.belowTarget:
        return Icons.trending_down;
      case RPEFeedback.onTarget:
        return Icons.check_circle;
      case RPEFeedback.aboveTarget:
        return Icons.trending_up;
      case RPEFeedback.tooHard:
        return Icons.warning;
    }
  }
}
