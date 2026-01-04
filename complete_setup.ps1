# AI Fitness Coach - Complete Setup Script
# Run this from project root: C:\Users\footlong\ai_fitness_coach

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "AI Fitness Coach - Auto Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Verify we're in the right directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "ERROR: Not in project root! Run from C:\Users\footlong\ai_fitness_coach" -ForegroundColor Red
    exit 1
}

Write-Host "`n[1/6] Creating app_constants.dart..." -ForegroundColor Yellow

$appConstants = @'
/// Application-wide constants
class AppConstants {
  // Hive box names
  static const String workoutBoxName = 'workouts';
  static const String programBoxName = 'programs';
  static const String profileBoxName = 'profiles';
  static const String sessionBoxName = 'sessions';

  // RPE defaults
  static const double defaultTargetRPE = 8.0;
  static const double minValidRPE = 6.0;
  static const double maxValidRPE = 10.0;

  // Workout limits
  static const int maxSetsPerExercise = 12;
  static const int maxWorkoutDurationMinutes = 180;

  // UI constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
}
'@

New-Item -ItemType File -Path "lib/core/constants/app_constants.dart" -Force | Out-Null
Set-Content -Path "lib/core/constants/app_constants.dart" -Value $appConstants
Write-Host "✅ Created app_constants.dart" -ForegroundColor Green

# ============================================

Write-Host "`n[2/6] Creating training_repository.dart interface..." -ForegroundColor Yellow

$trainingRepo = @'
import 'package:dartz/dartz.dart';

import '../models/workout_program.dart';
import '../../core/errors/failure.dart';

/// Abstract repository defining training data operations
abstract class TrainingRepository {
  // Program operations
  Future<Either<Failure, List<WorkoutProgram>>> getAllPrograms();
  Future<Either<Failure, WorkoutProgram>> getProgram(String id);
  Future<Either<Failure, void>> saveProgram(WorkoutProgram program);
  Future<Either<Failure, void>> deleteProgram(String id);
  Future<Either<Failure, void>> updateProgram(WorkoutProgram program);

  // Workout session operations
  Future<Either<Failure, List<dynamic>>> getWorkoutSessions();
  Future<Either<Failure, dynamic>> getWorkoutSession(String id);
  Future<Either<Failure, void>> saveWorkoutSession(dynamic session);
  Future<Either<Failure, void>> deleteWorkoutSession(String id);

  // User profile operations
  Future<Either<Failure, dynamic>> getUserProfile();
  Future<Either<Failure, void>> saveUserProfile(dynamic profile);
  Future<Either<Failure, void>> updateUserProfile(dynamic profile);
}
'@

New-Item -ItemType File -Path "lib/domain/repositories/training_repository.dart" -Force | Out-Null
Set-Content -Path "lib/domain/repositories/training_repository.dart" -Value $trainingRepo
Write-Host "✅ Created training_repository.dart" -ForegroundColor Green

# ============================================

Write-Host "`n[3/6] Moving repository implementation..." -ForegroundColor Yellow

if (Test-Path "lib/domain/repositories/training_repository_impl.dart") {
    Move-Item "lib/domain/repositories/training_repository_impl.dart" "lib/data/repositories/training_repository_impl.dart" -Force
    Write-Host "✅ Moved training_repository_impl.dart to data layer" -ForegroundColor Green
} else {
    Write-Host "⚠️  training_repository_impl.dart not found in domain/repositories" -ForegroundColor Yellow
}

# ============================================

Write-Host "`n[4/6] Checking pubspec.yaml..." -ForegroundColor Yellow

$pubspecContent = Get-Content "pubspec.yaml" -Raw

if ($pubspecContent -notmatch "flutter_riverpod") {
    Write-Host "⚠️  Riverpod not in pubspec.yaml - you need to add it manually" -ForegroundColor Yellow
    Write-Host "Add these to dependencies:" -ForegroundColor Cyan
    Write-Host "  flutter_riverpod: ^2.4.9" -ForegroundColor White
    Write-Host "  dartz: ^0.10.1" -ForegroundColor White
} else {
    Write-Host "✅ Riverpod already in pubspec.yaml" -ForegroundColor Green
}

# ============================================

Write-Host "`n[5/6] Checking providers.dart content..." -ForegroundColor Yellow

$providersContent = Get-Content "lib/core/providers/providers.dart" -Raw

if ($providersContent.Length -lt 100) {
    Write-Host "⚠️  providers.dart is empty or incomplete" -ForegroundColor Yellow
    Write-Host "You need to copy the content from the artifact!" -ForegroundColor Cyan
} else {
    Write-Host "✅ providers.dart has content" -ForegroundColor Green
}

# ============================================

Write-Host "`n[6/6] Final Structure Check..." -ForegroundColor Yellow

$requiredFiles = @(
    "lib/core/providers/providers.dart",
    "lib/core/constants/app_constants.dart",
    "lib/core/constants/rpe_thresholds.dart",
    "lib/domain/repositories/training_repository.dart",
    "lib/data/repositories/training_repository_impl.dart",
    "lib/services/program_service.dart",
    "lib/services/workout_session_service.dart",
    "lib/services/progression_service.dart"
)

Write-Host "`nFile Status:" -ForegroundColor Cyan
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        if ($size -gt 100) {
            Write-Host "✅ $file ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $file (EMPTY - $size bytes)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ $file (MISSING)" -ForegroundColor Red
    }
}

# ============================================

Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "Setup Script Complete!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Ensure providers.dart has the full content from artifact" -ForegroundColor White
Write-Host "2. Add Riverpod to pubspec.yaml if not present" -ForegroundColor White
Write-Host "3. Run: flutter pub get" -ForegroundColor White
Write-Host "4. Run: flutter analyze" -ForegroundColor White

Write-Host "`nPress any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")