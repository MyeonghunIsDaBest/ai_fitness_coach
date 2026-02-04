import 'package:flutter/material.dart';

/// Equipment types available for exercises
/// Used for filtering exercises based on available gym equipment
enum EquipmentType {
  barbell,
  dumbbell,
  kettlebell,
  cable,
  machine,
  bodyweight,
  resistanceBand,
  pullupBar,
  bench,
  rack,
  box,
  sled,
  rower,
  bike,
  rings,
  smithMachine,
  legPressMachine,
  cableMachine,
  medicineBall,
  battleRopes,
  trx,
  none;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case EquipmentType.barbell:
        return 'Barbell';
      case EquipmentType.dumbbell:
        return 'Dumbbell';
      case EquipmentType.kettlebell:
        return 'Kettlebell';
      case EquipmentType.cable:
        return 'Cable';
      case EquipmentType.machine:
        return 'Machine';
      case EquipmentType.bodyweight:
        return 'Bodyweight';
      case EquipmentType.resistanceBand:
        return 'Resistance Band';
      case EquipmentType.pullupBar:
        return 'Pull-up Bar';
      case EquipmentType.bench:
        return 'Bench';
      case EquipmentType.rack:
        return 'Squat Rack';
      case EquipmentType.box:
        return 'Plyo Box';
      case EquipmentType.sled:
        return 'Sled';
      case EquipmentType.rower:
        return 'Rowing Machine';
      case EquipmentType.bike:
        return 'Stationary Bike';
      case EquipmentType.rings:
        return 'Gymnastics Rings';
      case EquipmentType.smithMachine:
        return 'Smith Machine';
      case EquipmentType.legPressMachine:
        return 'Leg Press';
      case EquipmentType.cableMachine:
        return 'Cable Machine';
      case EquipmentType.medicineBall:
        return 'Medicine Ball';
      case EquipmentType.battleRopes:
        return 'Battle Ropes';
      case EquipmentType.trx:
        return 'TRX / Suspension';
      case EquipmentType.none:
        return 'No Equipment';
    }
  }

  /// Material icon for this equipment type
  IconData get icon {
    switch (this) {
      case EquipmentType.barbell:
        return Icons.fitness_center;
      case EquipmentType.dumbbell:
        return Icons.fitness_center;
      case EquipmentType.kettlebell:
        return Icons.sports_handball;
      case EquipmentType.cable:
        return Icons.cable;
      case EquipmentType.machine:
        return Icons.precision_manufacturing;
      case EquipmentType.bodyweight:
        return Icons.accessibility_new;
      case EquipmentType.resistanceBand:
        return Icons.straighten;
      case EquipmentType.pullupBar:
        return Icons.horizontal_rule;
      case EquipmentType.bench:
        return Icons.weekend;
      case EquipmentType.rack:
        return Icons.grid_on;
      case EquipmentType.box:
        return Icons.check_box_outline_blank;
      case EquipmentType.sled:
        return Icons.sledding;
      case EquipmentType.rower:
        return Icons.rowing;
      case EquipmentType.bike:
        return Icons.pedal_bike;
      case EquipmentType.rings:
        return Icons.circle_outlined;
      case EquipmentType.smithMachine:
        return Icons.view_column;
      case EquipmentType.legPressMachine:
        return Icons.airline_seat_legroom_extra;
      case EquipmentType.cableMachine:
        return Icons.cable;
      case EquipmentType.medicineBall:
        return Icons.sports_basketball;
      case EquipmentType.battleRopes:
        return Icons.waves;
      case EquipmentType.trx:
        return Icons.swap_vert;
      case EquipmentType.none:
        return Icons.do_not_disturb_alt;
    }
  }

  /// Whether this is commonly found in home gyms
  bool get isHomeGymCommon {
    switch (this) {
      case EquipmentType.dumbbell:
      case EquipmentType.kettlebell:
      case EquipmentType.resistanceBand:
      case EquipmentType.pullupBar:
      case EquipmentType.bodyweight:
      case EquipmentType.bench:
      case EquipmentType.none:
        return true;
      default:
        return false;
    }
  }

  /// Whether this is commonly found in commercial gyms
  bool get isCommercialGymCommon {
    switch (this) {
      case EquipmentType.none:
        return true;
      default:
        return true; // Most equipment is in commercial gyms
    }
  }
}
