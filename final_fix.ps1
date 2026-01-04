# Final Fix Script - Fixes remaining 220 errors
# Run from: C:\Users\footlong\ai_fitness_coach

Write-Host "=== FINAL FIX SCRIPT ===" -ForegroundColor Cyan
Write-Host "Fixing last 220 errors..." -ForegroundColor Yellow

# ============================================
# FIX 1: Fix program_templates.dart imports (100+ errors)
# ============================================

Write-Host "`n[1/5] Fixing program_templates.dart..." -ForegroundColor Cyan

$content = Get-Content "lib/data/program_templates.dart" -Raw

# Replace old imports with correct ones
$oldImports = @"
import '../models/enums.dart';
import '../models/exercise.dart';
import '../models/daily_workout.dart';
import '../models/program_week.dart';
import '../models/workout_program.dart';
"@

$newImports = @"
import '../core/enums/sport.dart';
import '../core/enums/phase.dart';
import '../domain/models/exercise.dart';
import '../domain/models/daily_workout.dart';
import '../domain/models/program_week.dart';
import '../domain/models/workout_program.dart';
"@

$content = $content.Replace($oldImports, $newImports)

Set-Content -Path "lib/data/program_templates.dart" -Value $content
Write-Host "✅ Fixed program_templates.dart" -ForegroundColor Green

# ============================================
# FIX 2: Fix data/repositories/training_repository.dart imports (30+ errors)
# ============================================

Write-Host "`n[2/5] Fixing data/repositories/training_repository.dart..." -ForegroundColor Cyan

$repoContent = Get-Content "lib/data/repositories/training_repository.dart" -Raw

# Replace old imports
$oldRepoImports = @"
import '../models/logged_set.dart';
import '../models/workout_program.dart';
import '../models/program_week.dart';
import '../models/athlete_profile.dart';
"@

$newRepoImports = @"
import '../../domain/models/logged_set.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/athlete_profile.dart';
"@

$repoContent = $repoContent.Replace($oldRepoImports, $newRepoImports)

Set-Content -Path "lib/data/repositories/training_repository.dart" -Value $repoContent
Write-Host "✅ Fixed data/repositories/training_repository.dart" -ForegroundColor Green

# ============================================
# FIX 3: Fix rpe_math.dart duplicate import
# ============================================

Write-Host "`n[3/5] Fixing rpe_math.dart duplicate..." -ForegroundColor Cyan

$rpeMathContent = Get-Content "lib/core/utils/rpe_math.dart" -Raw

# Remove the duplicate import at line 289
$lines = $rpeMathContent -split "`n"
$cleanedLines = @()
$mathImportCount = 0

foreach ($line in $lines) {
    if ($line -match "import 'dart:math'") {
        $mathImportCount++
        if ($mathImportCount -eq 1) {
            $cleanedLines += $line
        }
    } else {
        $cleanedLines += $line
    }
}

Set-Content -Path "lib/core/utils/rpe_math.dart" -Value ($cleanedLines -join "`n")
Write-Host "✅ Fixed rpe_math.dart" -ForegroundColor Green

# ============================================
# FIX 4: Fix services imports
# ============================================

Write-Host "`n[4/5] Fixing service imports..." -ForegroundColor Cyan

# Fix program_service.dart
$progServiceContent = Get-Content "lib/services/program_service.dart" -Raw
$progServiceContent = $progServiceContent.Replace("import '../models/workout_program.dart';", "import '../domain/models/workout_program.dart';")
$progServiceContent = $progServiceContent.Replace("import '../models/enums.dart';", "import '../core/enums/sport.dart';")
Set-Content -Path "lib/services/program_service.dart" -Value $progServiceContent

# Fix workout_service.dart if it exists
if (Test-Path "lib/services/workout_service.dart") {
    $workServiceContent = Get-Content "lib/services/workout_service.dart" -Raw
    $workServiceContent = $workServiceContent.Replace("import '../models/workout_program.dart';", "import '../domain/models/workout_program.dart';")
    Set-Content -Path "lib/services/workout_service.dart" -Value $workServiceContent
}

Write-Host "✅ Fixed service imports" -ForegroundColor Green

# ============================================
# FIX 5: Fix rpe_feedback_widget.dart
# ============================================

Write-Host "`n[5/5] Fixing rpe_feedback_widget.dart..." -ForegroundColor Cyan

$rpeFeedbackContent = @'
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
'@

Set-Content -Path "lib/features/rpe/rpe_feedback_widget.dart" -Value $rpeFeedbackContent
Write-Host "✅ Fixed rpe_feedback_widget.dart" -ForegroundColor Green

# ============================================
# SUMMARY
# ============================================

Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "FINAL FIX COMPLETE!" -ForegroundColor Green  
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "`nFixed:" -ForegroundColor Yellow
Write-Host "  ✅ program_templates.dart imports" -ForegroundColor White
Write-Host "  ✅ training_repository.dart imports" -ForegroundColor White
Write-Host "  ✅ rpe_math.dart duplicate import" -ForegroundColor White
Write-Host "  ✅ service file imports" -ForegroundColor White
Write-Host "  ✅ rpe_feedback_widget.dart" -ForegroundColor White

Write-Host "`nNext:" -ForegroundColor Yellow
Write-Host "  Run: flutter analyze" -ForegroundColor Cyan

Write-Host "`nExpected: Errors should drop to <100" -ForegroundColor Gray
Write-Host "  (Remaining errors will be in repository implementation)" -ForegroundColor DarkGray

Write-Host "`nPress any key..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")