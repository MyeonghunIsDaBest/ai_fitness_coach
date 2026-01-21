// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveDataSourceHash() => r'8b5d46e2aa0db382ff5f04ba33af580c4c0657e8';

/// Provider for the Hive data source
/// KeepAlive ensures singleton behavior
///
/// Copied from [hiveDataSource].
@ProviderFor(hiveDataSource)
final hiveDataSourceProvider = Provider<HiveDataSource>.internal(
  hiveDataSource,
  name: r'hiveDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hiveDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HiveDataSourceRef = ProviderRef<HiveDataSource>;
String _$athleteProfileHash() => r'9f13af1b5b1a4a23e8d2a7ac1b3b733b3a6d6b1e';

/// Provider for the athlete profile
/// Returns null if no profile exists
///
/// Copied from [athleteProfile].
@ProviderFor(athleteProfile)
final athleteProfileProvider =
    AutoDisposeFutureProvider<AthleteProfile?>.internal(
  athleteProfile,
  name: r'athleteProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$athleteProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AthleteProfileRef = AutoDisposeFutureProviderRef<AthleteProfile?>;
String _$allProgramsHash() => r'd77af168867bf10569c8194daf1c110cc2e6ff11';

/// Provider for all workout programs
///
/// Copied from [allPrograms].
@ProviderFor(allPrograms)
final allProgramsProvider =
    AutoDisposeFutureProvider<List<WorkoutProgram>>.internal(
  allPrograms,
  name: r'allProgramsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allProgramsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllProgramsRef = AutoDisposeFutureProviderRef<List<WorkoutProgram>>;
String _$activeProgramHash() => r'6a0a8bb0de0954086876a2c97cd59ed3231e64a7';

/// Provider for the active workout program
///
/// Copied from [activeProgram].
@ProviderFor(activeProgram)
final activeProgramProvider =
    AutoDisposeFutureProvider<WorkoutProgram?>.internal(
  activeProgram,
  name: r'activeProgramProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeProgramHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveProgramRef = AutoDisposeFutureProviderRef<WorkoutProgram?>;
String _$programByIdHash() => r'f4e44aa5c422ed15870ae167e91fd0a59a98f976';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for a specific program by ID
///
/// Copied from [programById].
@ProviderFor(programById)
const programByIdProvider = ProgramByIdFamily();

/// Provider for a specific program by ID
///
/// Copied from [programById].
class ProgramByIdFamily extends Family<AsyncValue<WorkoutProgram?>> {
  /// Provider for a specific program by ID
  ///
  /// Copied from [programById].
  const ProgramByIdFamily();

  /// Provider for a specific program by ID
  ///
  /// Copied from [programById].
  ProgramByIdProvider call(
    String id,
  ) {
    return ProgramByIdProvider(
      id,
    );
  }

  @override
  ProgramByIdProvider getProviderOverride(
    covariant ProgramByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programByIdProvider';
}

/// Provider for a specific program by ID
///
/// Copied from [programById].
class ProgramByIdProvider extends AutoDisposeFutureProvider<WorkoutProgram?> {
  /// Provider for a specific program by ID
  ///
  /// Copied from [programById].
  ProgramByIdProvider(
    String id,
  ) : this._internal(
          (ref) => programById(
            ref as ProgramByIdRef,
            id,
          ),
          from: programByIdProvider,
          name: r'programByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$programByIdHash,
          dependencies: ProgramByIdFamily._dependencies,
          allTransitiveDependencies:
              ProgramByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ProgramByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<WorkoutProgram?> Function(ProgramByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgramByIdProvider._internal(
        (ref) => create(ref as ProgramByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkoutProgram?> createElement() {
    return _ProgramByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProgramByIdRef on AutoDisposeFutureProviderRef<WorkoutProgram?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProgramByIdProviderElement
    extends AutoDisposeFutureProviderElement<WorkoutProgram?>
    with ProgramByIdRef {
  _ProgramByIdProviderElement(super.provider);

  @override
  String get id => (origin as ProgramByIdProvider).id;
}

String _$allSessionsHash() => r'f22154005a31d0ac01baf43b91f24d07b484bbb5';

/// Provider for all workout sessions
///
/// Copied from [allSessions].
@ProviderFor(allSessions)
final allSessionsProvider =
    AutoDisposeFutureProvider<List<WorkoutSession>>.internal(
  allSessions,
  name: r'allSessionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllSessionsRef = AutoDisposeFutureProviderRef<List<WorkoutSession>>;
String _$completedSessionsHash() => r'738017589e08a37a61a910e8c6941072a0803a83';

/// Provider for completed sessions only
///
/// Copied from [completedSessions].
@ProviderFor(completedSessions)
final completedSessionsProvider =
    AutoDisposeFutureProvider<List<WorkoutSession>>.internal(
  completedSessions,
  name: r'completedSessionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedSessionsRef
    = AutoDisposeFutureProviderRef<List<WorkoutSession>>;
String _$sessionsByProgramHash() => r'7f54827027fdb3b9851484ab6e7cf11ecb7ed9ab';

/// Provider for sessions by program
///
/// Copied from [sessionsByProgram].
@ProviderFor(sessionsByProgram)
const sessionsByProgramProvider = SessionsByProgramFamily();

/// Provider for sessions by program
///
/// Copied from [sessionsByProgram].
class SessionsByProgramFamily extends Family<AsyncValue<List<WorkoutSession>>> {
  /// Provider for sessions by program
  ///
  /// Copied from [sessionsByProgram].
  const SessionsByProgramFamily();

  /// Provider for sessions by program
  ///
  /// Copied from [sessionsByProgram].
  SessionsByProgramProvider call(
    String programId,
  ) {
    return SessionsByProgramProvider(
      programId,
    );
  }

  @override
  SessionsByProgramProvider getProviderOverride(
    covariant SessionsByProgramProvider provider,
  ) {
    return call(
      provider.programId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionsByProgramProvider';
}

/// Provider for sessions by program
///
/// Copied from [sessionsByProgram].
class SessionsByProgramProvider
    extends AutoDisposeFutureProvider<List<WorkoutSession>> {
  /// Provider for sessions by program
  ///
  /// Copied from [sessionsByProgram].
  SessionsByProgramProvider(
    String programId,
  ) : this._internal(
          (ref) => sessionsByProgram(
            ref as SessionsByProgramRef,
            programId,
          ),
          from: sessionsByProgramProvider,
          name: r'sessionsByProgramProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionsByProgramHash,
          dependencies: SessionsByProgramFamily._dependencies,
          allTransitiveDependencies:
              SessionsByProgramFamily._allTransitiveDependencies,
          programId: programId,
        );

  SessionsByProgramProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
  }) : super.internal();

  final String programId;

  @override
  Override overrideWith(
    FutureOr<List<WorkoutSession>> Function(SessionsByProgramRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionsByProgramProvider._internal(
        (ref) => create(ref as SessionsByProgramRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkoutSession>> createElement() {
    return _SessionsByProgramProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionsByProgramProvider && other.programId == programId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionsByProgramRef
    on AutoDisposeFutureProviderRef<List<WorkoutSession>> {
  /// The parameter `programId` of this provider.
  String get programId;
}

class _SessionsByProgramProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkoutSession>>
    with SessionsByProgramRef {
  _SessionsByProgramProviderElement(super.provider);

  @override
  String get programId => (origin as SessionsByProgramProvider).programId;
}

String _$sessionsByWeekHash() => r'5c672ee9e28a5745a37f66cdeb8ebcd0f8e5aab2';

/// Provider for sessions by week
///
/// Copied from [sessionsByWeek].
@ProviderFor(sessionsByWeek)
const sessionsByWeekProvider = SessionsByWeekFamily();

/// Provider for sessions by week
///
/// Copied from [sessionsByWeek].
class SessionsByWeekFamily extends Family<AsyncValue<List<WorkoutSession>>> {
  /// Provider for sessions by week
  ///
  /// Copied from [sessionsByWeek].
  const SessionsByWeekFamily();

  /// Provider for sessions by week
  ///
  /// Copied from [sessionsByWeek].
  SessionsByWeekProvider call(
    String programId,
    int weekNumber,
  ) {
    return SessionsByWeekProvider(
      programId,
      weekNumber,
    );
  }

  @override
  SessionsByWeekProvider getProviderOverride(
    covariant SessionsByWeekProvider provider,
  ) {
    return call(
      provider.programId,
      provider.weekNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionsByWeekProvider';
}

/// Provider for sessions by week
///
/// Copied from [sessionsByWeek].
class SessionsByWeekProvider
    extends AutoDisposeFutureProvider<List<WorkoutSession>> {
  /// Provider for sessions by week
  ///
  /// Copied from [sessionsByWeek].
  SessionsByWeekProvider(
    String programId,
    int weekNumber,
  ) : this._internal(
          (ref) => sessionsByWeek(
            ref as SessionsByWeekRef,
            programId,
            weekNumber,
          ),
          from: sessionsByWeekProvider,
          name: r'sessionsByWeekProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionsByWeekHash,
          dependencies: SessionsByWeekFamily._dependencies,
          allTransitiveDependencies:
              SessionsByWeekFamily._allTransitiveDependencies,
          programId: programId,
          weekNumber: weekNumber,
        );

  SessionsByWeekProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
    required this.weekNumber,
  }) : super.internal();

  final String programId;
  final int weekNumber;

  @override
  Override overrideWith(
    FutureOr<List<WorkoutSession>> Function(SessionsByWeekRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionsByWeekProvider._internal(
        (ref) => create(ref as SessionsByWeekRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
        weekNumber: weekNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkoutSession>> createElement() {
    return _SessionsByWeekProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionsByWeekProvider &&
        other.programId == programId &&
        other.weekNumber == weekNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);
    hash = _SystemHash.combine(hash, weekNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionsByWeekRef on AutoDisposeFutureProviderRef<List<WorkoutSession>> {
  /// The parameter `programId` of this provider.
  String get programId;

  /// The parameter `weekNumber` of this provider.
  int get weekNumber;
}

class _SessionsByWeekProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkoutSession>>
    with SessionsByWeekRef {
  _SessionsByWeekProviderElement(super.provider);

  @override
  String get programId => (origin as SessionsByWeekProvider).programId;
  @override
  int get weekNumber => (origin as SessionsByWeekProvider).weekNumber;
}

String _$mostRecentSessionHash() => r'0a5397fe0ed85d45dd1a53ebf5c305ced93907ac';

/// Provider for most recent session
///
/// Copied from [mostRecentSession].
@ProviderFor(mostRecentSession)
final mostRecentSessionProvider =
    AutoDisposeFutureProvider<WorkoutSession?>.internal(
  mostRecentSession,
  name: r'mostRecentSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mostRecentSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MostRecentSessionRef = AutoDisposeFutureProviderRef<WorkoutSession?>;
String _$totalCompletedWorkoutsHash() =>
    r'dcff1ba2c09fded1349767aa6a29260e21377075';

/// Provider for total completed workouts count
///
/// Copied from [totalCompletedWorkouts].
@ProviderFor(totalCompletedWorkouts)
final totalCompletedWorkoutsProvider = AutoDisposeFutureProvider<int>.internal(
  totalCompletedWorkouts,
  name: r'totalCompletedWorkoutsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalCompletedWorkoutsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TotalCompletedWorkoutsRef = AutoDisposeFutureProviderRef<int>;
String _$isWorkoutCompletedHash() =>
    r'431e05192239643f56d4bd44d5d28cdf5a184661';

/// Provider to check if a workout is completed
///
/// Copied from [isWorkoutCompleted].
@ProviderFor(isWorkoutCompleted)
const isWorkoutCompletedProvider = IsWorkoutCompletedFamily();

/// Provider to check if a workout is completed
///
/// Copied from [isWorkoutCompleted].
class IsWorkoutCompletedFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if a workout is completed
  ///
  /// Copied from [isWorkoutCompleted].
  const IsWorkoutCompletedFamily();

  /// Provider to check if a workout is completed
  ///
  /// Copied from [isWorkoutCompleted].
  IsWorkoutCompletedProvider call(
    String programId,
    int weekNumber,
    int dayNumber,
  ) {
    return IsWorkoutCompletedProvider(
      programId,
      weekNumber,
      dayNumber,
    );
  }

  @override
  IsWorkoutCompletedProvider getProviderOverride(
    covariant IsWorkoutCompletedProvider provider,
  ) {
    return call(
      provider.programId,
      provider.weekNumber,
      provider.dayNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isWorkoutCompletedProvider';
}

/// Provider to check if a workout is completed
///
/// Copied from [isWorkoutCompleted].
class IsWorkoutCompletedProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if a workout is completed
  ///
  /// Copied from [isWorkoutCompleted].
  IsWorkoutCompletedProvider(
    String programId,
    int weekNumber,
    int dayNumber,
  ) : this._internal(
          (ref) => isWorkoutCompleted(
            ref as IsWorkoutCompletedRef,
            programId,
            weekNumber,
            dayNumber,
          ),
          from: isWorkoutCompletedProvider,
          name: r'isWorkoutCompletedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isWorkoutCompletedHash,
          dependencies: IsWorkoutCompletedFamily._dependencies,
          allTransitiveDependencies:
              IsWorkoutCompletedFamily._allTransitiveDependencies,
          programId: programId,
          weekNumber: weekNumber,
          dayNumber: dayNumber,
        );

  IsWorkoutCompletedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
    required this.weekNumber,
    required this.dayNumber,
  }) : super.internal();

  final String programId;
  final int weekNumber;
  final int dayNumber;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsWorkoutCompletedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsWorkoutCompletedProvider._internal(
        (ref) => create(ref as IsWorkoutCompletedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
        weekNumber: weekNumber,
        dayNumber: dayNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsWorkoutCompletedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsWorkoutCompletedProvider &&
        other.programId == programId &&
        other.weekNumber == weekNumber &&
        other.dayNumber == dayNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);
    hash = _SystemHash.combine(hash, weekNumber.hashCode);
    hash = _SystemHash.combine(hash, dayNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsWorkoutCompletedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `programId` of this provider.
  String get programId;

  /// The parameter `weekNumber` of this provider.
  int get weekNumber;

  /// The parameter `dayNumber` of this provider.
  int get dayNumber;
}

class _IsWorkoutCompletedProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsWorkoutCompletedRef {
  _IsWorkoutCompletedProviderElement(super.provider);

  @override
  String get programId => (origin as IsWorkoutCompletedProvider).programId;
  @override
  int get weekNumber => (origin as IsWorkoutCompletedProvider).weekNumber;
  @override
  int get dayNumber => (origin as IsWorkoutCompletedProvider).dayNumber;
}

String _$athleteProfileNotifierHash() =>
    r'0c1df53c158a9c39db1f1ab23789cef5bca160ea';

/// Notifier for managing athlete profile state
///
/// Copied from [AthleteProfileNotifier].
@ProviderFor(AthleteProfileNotifier)
final athleteProfileNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AthleteProfileNotifier, AthleteProfile?>.internal(
  AthleteProfileNotifier.new,
  name: r'athleteProfileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$athleteProfileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AthleteProfileNotifier = AutoDisposeAsyncNotifier<AthleteProfile?>;
String _$workoutProgramNotifierHash() =>
    r'dd3db673bdf0ca6cbd87f1e8ad36b34f9d6b6818';

/// Notifier for managing workout program state
///
/// Copied from [WorkoutProgramNotifier].
@ProviderFor(WorkoutProgramNotifier)
final workoutProgramNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WorkoutProgramNotifier, List<WorkoutProgram>>.internal(
  WorkoutProgramNotifier.new,
  name: r'workoutProgramNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutProgramNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutProgramNotifier
    = AutoDisposeAsyncNotifier<List<WorkoutProgram>>;
String _$workoutSessionNotifierHash() =>
    r'bdf65f543ee626439ebb12f1919c1753df764598';

/// Notifier for managing workout session state
///
/// Copied from [WorkoutSessionNotifier].
@ProviderFor(WorkoutSessionNotifier)
final workoutSessionNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WorkoutSessionNotifier, List<WorkoutSession>>.internal(
  WorkoutSessionNotifier.new,
  name: r'workoutSessionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutSessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutSessionNotifier
    = AutoDisposeAsyncNotifier<List<WorkoutSession>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
