/// Base class for all failures in the app
/// This allows predictable, testable error handling
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

//
// ──────────────────────────────────────────────
// GENERIC FAILURES
// ──────────────────────────────────────────────
//

class UnknownFailure extends Failure {
  const UnknownFailure([String message = "An unknown error occurred"])
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class StorageFailure extends Failure {
  const StorageFailure([String message = "Failed to save or load data"])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = "No internet connection"])
      : super(message);
}

//
// ──────────────────────────────────────────────
// AUTH / USER FAILURES (Future Firebase/Auth)
// ──────────────────────────────────────────────
//

class AuthFailure extends Failure {
  const AuthFailure([String message = "Authentication failed"])
      : super(message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super("User profile not found");
}

//
// ──────────────────────────────────────────────
// WORKOUT & TRAINING FAILURES
// ──────────────────────────────────────────────
//

class WorkoutNotFoundFailure extends Failure {
  const WorkoutNotFoundFailure() : super("Workout not found");
}

class WorkoutSaveFailure extends Failure {
  const WorkoutSaveFailure() : super("Failed to save workout session");
}

class IncompleteWorkoutFailure extends Failure {
  const IncompleteWorkoutFailure() : super("Workout session is incomplete");
}

//
// ──────────────────────────────────────────────
// RPE-SPECIFIC FAILURES (VERY IMPORTANT FOR YOU)
// ──────────────────────────────────────────────
//

class InvalidRpeFailure extends Failure {
  const InvalidRpeFailure() : super("RPE must be between 6.0 and 10.0");
}

class RpeCalculationFailure extends Failure {
  const RpeCalculationFailure() : super("Unable to calculate session RPE");
}

class NoRpeLoggedFailure extends Failure {
  const NoRpeLoggedFailure() : super("No RPE data available for this session");
}

//
// ──────────────────────────────────────────────
// PROGRAM / PROGRESSION FAILURES
// ──────────────────────────────────────────────
//

class ProgramNotFoundFailure extends Failure {
  const ProgramNotFoundFailure() : super("Training program not found");
}

class WeekLockedFailure extends Failure {
  const WeekLockedFailure() : super("This training week is locked");
}

class ProgressionFailure extends Failure {
  const ProgressionFailure() : super("Unable to adjust next week's load");
}

//
// ──────────────────────────────────────────────
// AI / GPT FAILURES (FOR FUTURE INTEGRATION)
// ──────────────────────────────────────────────
//

class AiRequestFailure extends Failure {
  const AiRequestFailure([String message = "AI request failed"])
      : super(message);
}

class AiRateLimitFailure extends Failure {
  const AiRateLimitFailure() : super("AI rate limit exceeded. Try again later");
}

class VisionAnalysisFailure extends Failure {
  const VisionAnalysisFailure()
      : super("Failed to analyze form from image/video");
}
