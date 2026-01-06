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
  final Map<String, String>? errors; // NEW: Track multiple field errors

  const ValidationFailure(String message, [this.errors]) : super(message);

  @override
  String toString() {
    if (errors == null || errors!.isEmpty) return message;
    final errorList =
        errors!.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return '$message ($errorList)';
  }
}

class StorageFailure extends Failure {
  const StorageFailure([String message = "Failed to save or load data"])
      : super(message);
}

class CacheFailure extends Failure {
  // NEW: Specific cache errors
  const CacheFailure([String message = "Failed to cache data"])
      : super(message);
}

class RetrievalFailure extends Failure {
  // NEW: Specific load errors
  const RetrievalFailure([String message = "Failed to retrieve data"])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = "No internet connection"])
      : super(message);
}

class ServerFailure extends Failure {
  // NEW: Track HTTP status
  final int? statusCode;

  const ServerFailure(String message, [this.statusCode]) : super(message);

  @override
  String toString() {
    if (statusCode != null) return '$message (Status: $statusCode)';
    return message;
  }
}

class TimeoutFailure extends Failure {
  // NEW: Handle slow connections
  const TimeoutFailure([String message = "Request timed out"]) : super(message);
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

class InvalidCredentialsFailure extends Failure {
  // NEW: Specific login error
  const InvalidCredentialsFailure() : super("Invalid username or password");
}

class SessionExpiredFailure extends Failure {
  // NEW: Token expiry
  const SessionExpiredFailure() : super("Session expired. Please log in again");
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
  final String? workoutId; // NEW: Track which workout

  const WorkoutNotFoundFailure([this.workoutId])
      : super(workoutId != null
            ? "Workout not found: $workoutId"
            : "Workout not found");
}

class WorkoutSaveFailure extends Failure {
  const WorkoutSaveFailure() : super("Failed to save workout session");
}

class IncompleteWorkoutFailure extends Failure {
  // YOUR EXCELLENT ADDITION
  const IncompleteWorkoutFailure() : super("Workout session is incomplete");
}

class WorkoutCompletedFailure extends Failure {
  // NEW: Prevent editing done workouts
  const WorkoutCompletedFailure() : super("Cannot modify a completed workout");
}

//
// ──────────────────────────────────────────────
// RPE-SPECIFIC FAILURES (YOUR DOMAIN EXPERTISE!)
// ──────────────────────────────────────────────
//

class InvalidRpeFailure extends Failure {
  final double? rpeValue; // NEW: Show actual value in error

  const InvalidRpeFailure([this.rpeValue])
      : super(rpeValue != null
            ? "Invalid RPE: $rpeValue. Must be between 6.0 and 10.0"
            : "RPE must be between 6.0 and 10.0");
}

class RpeCalculationFailure extends Failure {
  // YOUR EXCELLENT ADDITION
  const RpeCalculationFailure() : super("Unable to calculate session RPE");
}

class NoRpeLoggedFailure extends Failure {
  // YOUR EXCELLENT ADDITION
  const NoRpeLoggedFailure() : super("No RPE data available for this session");
}

class InvalidWeightFailure extends Failure {
  // NEW: Validate weights
  final double? weight;

  const InvalidWeightFailure([this.weight])
      : super(weight != null
            ? "Invalid weight: $weight. Must be positive"
            : "Weight must be a positive number");
}

//
// ──────────────────────────────────────────────
// PROGRAM / PROGRESSION FAILURES
// ──────────────────────────────────────────────
//

class ProgramNotFoundFailure extends Failure {
  final String? programId;

  const ProgramNotFoundFailure([this.programId])
      : super(programId != null
            ? "Training program not found: $programId"
            : "Training program not found");
}

class ProgramAlreadyActiveFailure extends Failure {
  // NEW: Prevent duplicates
  const ProgramAlreadyActiveFailure(String programName)
      : super('Program "$programName" is already active');
}

class WeekLockedFailure extends Failure {
  final int? weekNumber;

  const WeekLockedFailure([this.weekNumber])
      : super(weekNumber != null
            ? "Week $weekNumber is locked"
            : "This training week is locked");
}

class RestDayFailure extends Failure {
  // NEW: Handle rest days
  const RestDayFailure() : super("No workout scheduled for this day");
}

class ProgressionFailure extends Failure {
  // YOUR EXCELLENT ADDITION
  const ProgressionFailure() : super("Unable to adjust next week's load");
}

class ExerciseNotFoundFailure extends Failure {
  // NEW: Track exercise errors
  final String? exerciseName;

  const ExerciseNotFoundFailure([this.exerciseName])
      : super(exerciseName != null
            ? "Exercise not found: $exerciseName"
            : "Exercise not found");
}

//
// ──────────────────────────────────────────────
// PERMISSION FAILURES (CRITICAL FOR CAMERA!)
// ──────────────────────────────────────────────
//

class CameraPermissionFailure extends Failure {
  // ⚠️ MUST HAVE
  const CameraPermissionFailure()
      : super("Camera permission denied. Enable in Settings.");
}

class StoragePermissionFailure extends Failure {
  // ⚠️ MUST HAVE
  const StoragePermissionFailure()
      : super("Storage permission denied. Enable in Settings.");
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
  // YOUR EXCELLENT ADDITION
  const AiRateLimitFailure() : super("AI rate limit exceeded. Try again later");
}

class VisionAnalysisFailure extends Failure {
  // YOUR EXCELLENT ADDITION
  const VisionAnalysisFailure()
      : super("Failed to analyze form from image/video");
}

class ProgramGenerationFailure extends Failure {
  // NEW: AI program creation
  const ProgramGenerationFailure(
      [String message = "Failed to generate program"])
      : super(message);
}

//
// ══════════════════════════════════════════════
// 🚀 EXTENSION METHODS (GAME CHANGER!)
// ══════════════════════════════════════════════
//

extension FailureExtensions on Failure {
  /// Check if this is a network-related failure
  bool get isNetworkFailure =>
      this is NetworkFailure || this is ServerFailure || this is TimeoutFailure;

  /// Check if this is a not-found failure
  bool get isNotFoundFailure =>
      this is WorkoutNotFoundFailure ||
      this is ProgramNotFoundFailure ||
      this is UserNotFoundFailure ||
      this is ExerciseNotFoundFailure;

  /// Check if this is a validation failure
  bool get isValidationFailure =>
      this is ValidationFailure ||
      this is InvalidRpeFailure ||
      this is InvalidWeightFailure;

  /// Check if this is an RPE-related failure
  bool get isRpeFailure =>
      this is InvalidRpeFailure ||
      this is RpeCalculationFailure ||
      this is NoRpeLoggedFailure;

  /// Check if this is a permission failure
  bool get isPermissionFailure =>
      this is CameraPermissionFailure || this is StoragePermissionFailure;

  /// Get user-friendly error message
  /// This is CRITICAL for good UX!
  String get userMessage {
    // Network errors
    if (this is NetworkFailure) {
      return 'Check your internet connection and try again';
    }
    if (this is ServerFailure) {
      return 'Server error. Please try again later';
    }
    if (this is TimeoutFailure) {
      return 'Request timed out. Please try again';
    }

    // Storage errors
    if (this is StorageFailure || this is CacheFailure) {
      return 'Failed to save data. Please try again';
    }
    if (this is RetrievalFailure) {
      return 'Failed to load data. Please try again';
    }

    // Validation errors
    if (this is ValidationFailure) {
      return 'Please check your input and try again';
    }

    // Permission errors
    if (this is CameraPermissionFailure) {
      return 'Camera access is required. Please enable in Settings';
    }
    if (this is StoragePermissionFailure) {
      return 'Storage access is required. Please enable in Settings';
    }

    // AI errors
    if (this is AiRateLimitFailure) {
      return 'Too many requests. Please wait a moment';
    }

    // Not found errors
    if (isNotFoundFailure) {
      return 'The requested item could not be found';
    }

    // Default: use the original message
    return message;
  }

  /// Get appropriate icon for this failure type
  String get icon {
    if (isNetworkFailure) return '📡';
    if (isNotFoundFailure) return '🔍';
    if (isValidationFailure) return '⚠️';
    if (isRpeFailure) return '💪';
    if (isPermissionFailure) return '🔐';
    if (this is AiRequestFailure) return '🤖';
    return '❌';
  }
}
