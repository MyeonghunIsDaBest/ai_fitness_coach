class RPEFeedbackWidget extends StatelessWidget {
  final double currentRPE;
  final int targetMin;
  final int targetMax;

  const RPEFeedbackWidget({
    required this.currentRPE,
    required this.targetMin,
    required this.targetMax,
  });

  @override
  Widget build(BuildContext context) {
    final feedback = RPEMath.getFeedback(currentRPE, targetMin, targetMax);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: feedback.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: feedback.color),
      ),
      child: Row(
        children: [
          Icon(_getIcon(feedback), color: feedback.color, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              feedback.message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: feedback.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(RPEFeedback feedback) {
    switch (feedback) {
      case RPEFeedback.onTarget:
        return Icons.check_circle;
      case RPEFeedback.tooHard:
        return Icons.warning_amber;
      default:
        return Icons.info_outline;
    }
  }
}
