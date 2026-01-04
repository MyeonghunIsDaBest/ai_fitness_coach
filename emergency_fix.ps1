# Emergency Fix Script - Fixes Most Import Errors
# Run from: C:\Users\footlong\ai_fitness_coach

Write-Host "=== EMERGENCY FIX SCRIPT ===" -ForegroundColor Red
Write-Host "Fixing 300+ cascading errors..." -ForegroundColor Yellow

# ============================================
# FIX 1: Create workout_session_service.dart
# ============================================

Write-Host "`n[1/6] Creating workout_session_service.dart..." -ForegroundColor Cyan

$workoutService = @'
import '../domain/repositories/training_repository.dart';

/// Service for managing workout sessions
class WorkoutSessionService {
  final TrainingRepository _repository;

  WorkoutSessionService(this._repository);

  Future<void> saveSession(dynamic session) async {
    // Placeholder - will implement later
  }

  Future<List<dynamic>> getSessions() async {
    return [];
  }

  Future<dynamic> getSession(String id) async {
    return null;
  }

  Future<void> deleteSession(String id) async {
    // Placeholder
  }
}
'@

Set-Content -Path "lib/services/workout_session_service.dart" -Value $workoutService
Write-Host "✅ Created workout_session_service.dart" -ForegroundColor Green

# ============================================
# FIX 2: Fix rpe_math.dart imports
# ============================================

Write-Host "`n[2/6] Fixing rpe_math.dart imports..." -ForegroundColor Cyan

$rpeMathContent = Get-Content "lib/core/utils/rpe_math.dart" -Raw

# Move dart:math import to top and fix others
$rpeMathContent = $rpeMathContent -replace "import 'rpe_feedback.dart';", "import '../enums/rpe_feedback.dart';"
$rpeMathContent = $rpeMathContent -replace "import 'rpe_thresholds.dart';", "import '../constants/rpe_thresholds.dart';"
$rpeMathContent = $rpeMathContent -replace "// Import dart:math for sqrt function\s+import 'dart:math' as math;", "import 'dart:math' as math;"

# Add import at top if not there
if ($rpeMathContent -notmatch "import 'dart:math'") {
    $rpeMathContent = "import 'dart:math' as math;`n" + $rpeMathContent
}

Set-Content -Path "lib/core/utils/rpe_math.dart" -Value $rpeMathContent
Write-Host "✅ Fixed rpe_math.dart imports" -ForegroundColor Green

# ============================================
# FIX 3: Fix session_stats.dart imports  
# ============================================

Write-Host "`n[3/6] Fixing session_stats.dart imports..." -ForegroundColor Cyan

$sessionStatsContent = Get-Content "lib/core/utils/session_stats.dart" -Raw
$sessionStatsContent = $sessionStatsContent -replace "import '../models/logged_set.dart';", "import '../../domain/models/logged_set.dart';"

Set-Content -Path "lib/core/utils/session_stats.dart" -Value $sessionStatsContent
Write-Host "✅ Fixed session_stats.dart imports" -ForegroundColor Green

# ============================================
# FIX 4: Fix program_templates.dart imports
# ============================================

Write-Host "`n[4/6] Fixing program_templates.dart imports..." -ForegroundColor Cyan

$templatesContent = Get-Content "lib/data/program_templates.dart" -Raw

$newImports = @"
import '../core/enums/sport.dart';
import '../core/enums/phase.dart';
import '../domain/models/exercise.dart';
import '../domain/models/daily_workout.dart';
import '../domain/models/program_week.dart';
import '../domain/models/workout_program.dart';
"@

# Replace old imports
$templatesContent = $templatesContent -replace "import '../models/enums.dart';.*?import '../models/workout_program.dart';", $newImports

Set-Content -Path "lib/data/program_templates.dart" -Value $templatesContent
Write-Host "✅ Fixed program_templates.dart imports" -ForegroundColor Green

# ============================================
# FIX 5: Clean main.dart duplicates
# ============================================

Write-Host "`n[5/6] Cleaning main.dart..." -ForegroundColor Cyan

$mainContent = Get-Content "lib/main.dart" -Raw

# Find where duplication starts (around line 331)
$lines = $mainContent -split "`n"
$cleanLines = @()
$foundFirstSplash = $false
$skipUntilEnd = $false

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    
    # Detect duplicate SplashScreen
    if ($line -match "class SplashScreen" -and $foundFirstSplash) {
        $skipUntilEnd = $true
        Write-Host "⚠️  Found duplicate at line $i - removing..." -ForegroundColor Yellow
    }
    
    if ($line -match "class SplashScreen" -and -not $foundFirstSplash) {
        $foundFirstSplash = $true
    }
    
    # Stop skipping after the closing brace of duplicate class
    if ($skipUntilEnd -and $line -match "^}$" -and $lines[$i-1] -match "^\s*}$") {
        $skipUntilEnd = $false
        continue
    }
    
    if (-not $skipUntilEnd) {
        $cleanLines += $line
    }
}

$cleanMain = $cleanLines -join "`n"

# Remove duplicate imports
$cleanMain = $cleanMain -replace "(?m)^import.*?workout_session_service.*?`n", ""
$cleanMain = $cleanMain -replace "(?m)^import 'domain/repositories/training_repository.dart';.*?`n(?=.*?^import 'domain/repositories/training_repository.dart';)", ""

Set-Content -Path "lib/main.dart" -Value $cleanMain
Write-Host "✅ Cleaned main.dart" -ForegroundColor Green

# ============================================
# FIX 6: Fix providers.dart service imports
# ============================================

Write-Host "`n[6/6] Fixing providers.dart..." -ForegroundColor Cyan

$providersContent = Get-Content "lib/core/providers/providers.dart" -Raw

# Ensure correct import
if ($providersContent -notmatch "import '../../services/workout_session_service.dart';") {
    $providersContent = $providersContent -replace "import '../../services/workout_session_service.dart';", ""
    $providersContent = "import 'package:flutter_riverpod/flutter_riverpod.dart';`nimport 'package:hive_flutter/hive_flutter.dart';`n`nimport '../enums/sport.dart';`nimport '../../domain/repositories/training_repository.dart';`nimport '../../domain/models/workout_program.dart';`nimport '../../domain/models/daily_workout.dart';`nimport '../../data/repositories/training_repository_impl.dart';`nimport '../../services/program_service.dart';`nimport '../../services/rpe_feedback_service.dart';`nimport '../../services/progression_service.dart';`nimport '../../services/workout_session_service.dart';`n" + ($providersContent -split "`n" | Select-Object -Skip 10 | Out-String)
}

Set-Content -Path "lib/core/providers/providers.dart" -Value $providersContent
Write-Host "✅ Fixed providers.dart" -ForegroundColor Green

# ============================================
# SUMMARY
# ============================================

Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "FIX SCRIPT COMPLETE!" -ForegroundColor Green  
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "`nFixed:" -ForegroundColor Yellow
Write-Host "  ✅ Created workout_session_service.dart" -ForegroundColor White
Write-Host "  ✅ Fixed rpe_math.dart imports" -ForegroundColor White
Write-Host "  ✅ Fixed session_stats.dart imports" -ForegroundColor White
Write-Host "  ✅ Fixed program_templates.dart imports" -ForegroundColor White
Write-Host "  ✅ Cleaned main.dart duplicates" -ForegroundColor White
Write-Host "  ✅ Fixed providers.dart imports" -ForegroundColor White

Write-Host "`nNext Step:" -ForegroundColor Yellow
Write-Host "  Run: flutter pub get" -ForegroundColor Cyan
Write-Host "  Then: flutter analyze" -ForegroundColor Cyan

Write-Host "`nExpected: Errors should drop from 300+ to <50" -ForegroundColor Gray

Write-Host "`nPress any key to close..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")