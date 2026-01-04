This is based on Flutter Analyzed Result

wwarning - The include file 'package:flutter_lints/flutter.yaml' in
       'C:\Users\footlong\ai_fitness_coach\analysis_options.yaml' can't be found when analyzing
       'C:\Users\footlong\ai_fitness_coach' - analysis_options.yaml:10:10 - include_file_not_found
  error - The argument type 'Provider<Box<dynamic>>' can't be assigned to the parameter type
         'ProviderListenable<Box<Map<dynamic, dynamic>>>'.  - lib\core\providers\providers.dart:47:27 -
         argument_type_not_assignable
  error - The argument type 'Provider<Box<dynamic>>' can't be assigned to the parameter type
         'ProviderListenable<Box<Map<dynamic, dynamic>>>'.  - lib\core\providers\providers.dart:48:27 -
         argument_type_not_assignable
  error - The argument type 'Provider<Box<dynamic>>' can't be assigned to the parameter type
         'ProviderListenable<Box<Map<dynamic, dynamic>>>'.  - lib\core\providers\providers.dart:49:27 -
         argument_type_not_assignable
  error - The argument type 'Provider<Box<dynamic>>' can't be assigned to the parameter type
         'ProviderListenable<Box<Map<dynamic, dynamic>>>'.  - lib\core\providers\providers.dart:50:27 -
         argument_type_not_assignable
  error - Too many positional arguments: 0 expected, but 1 found - lib\core\providers\providers.dart:59:25 -
         extra_positional_arguments
  error - Too many positional arguments: 0 expected, but 1 found - lib\core\providers\providers.dart:67:29 -
         extra_positional_arguments
  error - The argument type 'Never Function(dynamic)' can't be assigned to the parameter type
         'FutureOr<List<WorkoutProgram>>'.  - lib\core\providers\providers.dart:93:5 - argument_type_not_assignable        
  error - The argument type 'FutureOr<List<WorkoutProgram>> Function(FutureOr<List<WorkoutProgram>>)' can't be assigned to 
         the parameter type 'FutureOr<List<WorkoutProgram>> Function(FutureOr<List<WorkoutProgram>>, WorkoutProgram)'.  -  
         lib\core\providers\providers.dart:94:5 - argument_type_not_assignable
  error - The method 'getProgram' isn't defined for the type 'TrainingRepository' -
         lib\core\providers\providers.dart:104:35 - undefined_method
  error - The getter 'workouts' isn't defined for the type 'ProgramWeek' - lib\core\providers\providers.dart:123:15 -      
         undefined_getter
warning - The value of the local variable 'targetMid' isn't used - lib\core\utils\rpe_math.dart:89:11 -
       unused_local_variable
warning - The value of the field '_workoutBox' isn't used - lib\data\repositories\training_repository_impl.dart:12:36 -    
       unused_field
  error - The method 'toJson' isn't defined for the type 'AthleteProfile' -
         lib\data\repositories\training_repository_impl.dart:735:20 - undefined_method
  error - The method 'fromJson' isn't defined for the type 'AthleteProfile' -
         lib\data\repositories\training_repository_impl.dart:740:27 - undefined_method
warning - Unused import: '../../core/enums/lift_type.dart' - lib\domain\models\daily_workout.dart:2:8 - unused_import      
  error - The argument type 'List<MuscleGroup>' can't be assigned to the parameter type 'Iterable<MuscleGroup>'.  -        
         lib\domain\models\daily_workout.dart:136:21 - argument_type_not_assignable
  error - The method 'toJson' isn't defined for the type 'Exercise' - lib\domain\models\daily_workout.dart:204:43 -        
         undefined_method
  error - The method 'fromJson' isn't defined for the type 'Exercise' - lib\domain\models\daily_workout.dart:222:32 -      
         undefined_method
warning - Unused import: 'athlete_profile.dart' - lib\domain\models\workout_program.dart:4:8 - unused_import
warning - The value of the local variable 'targetMid' isn't used - lib\domain\usecases\get_fatigue_status.dart:29:11 -     
       unused_local_variable
warning - Unused import: '../../core/enums/week_type.dart' -
       lib\features\program_selection\program_selection_screen.dart:9:8 - unused_import
   info - The declaration '_getIcon' isn't referenced - lib\features\rpe\rpe_feedback_widget.dart:47:12 - unused_element   
warning - Unused import: '../../domain/repositories/training_repository.dart' -
       lib\features\workout\workout_logger_screen.dart:5:8 - unused_import
warning - The value of the field '_logSetUseCase' isn't used - lib\features\workout\workout_logger_screen.dart:54:24 -
       unused_field
  error - The method 'startSession' isn't defined for the type 'WorkoutSessionService' -
         lib\features\workout\workout_logger_screen.dart:70:48 - undefined_method
  error - The method 'logSet' isn't defined for the type 'WorkoutSessionService' -
         lib\features\workout\workout_logger_screen.dart:678:35 - undefined_method
  error - The method 'completeSession' isn't defined for the type 'WorkoutSessionService' -
         lib\features\workout\workout_logger_screen.dart:777:45 - undefined_method
  error - Too many positional arguments: 0 expected, but 1 found - lib\main.dart:44:41 - extra_positional_arguments        
  error - Too many positional arguments: 0 expected, but 1 found - lib\main.dart:46:49 - extra_positional_arguments        
  error - The named parameter 'programService' isn't defined - lib\main.dart:140:13 - undefined_named_parameter
  error - Target of URI doesn't exist: '../data/program_templates.dart' - lib\services\program_service.dart:3:8 -
         uri_does_not_exist
  error - Undefined name 'ProgramTemplates' - lib\services\program_service.dart:13:12 - undefined_identifier
  error - The name 'WorkoutSession' isn't a type, so it can't be used as a type argument -
         lib\services\progression_service.dart:3:19 - non_type_as_type_argument
  error - Undefined class 'ProgramWeek' - lib\services\progression_service.dart:4:14 - undefined_class
  error - The property 'sets' can't be unconditionally accessed because the receiver can be 'null' -
         lib\services\progression_service.dart:9:30 - unchecked_use_of_nullable_value
  error - Undefined name 'RPEMath' - lib\services\progression_service.dart:12:24 - undefined_identifier
  error - Undefined name 'RPEMath' - lib\services\progression_service.dart:15:9 - undefined_identifier
  error - Undefined name 'RPEMath' - lib\services\progression_service.dart:20:9 - undefined_identifier
warning - The value of the field '_repository' isn't used - lib\services\workout_session_service.dart:5:28 - unused_field  
  error - Target of URI doesn't exist: 'package:flutter_test/flutter_test.dart' - test\widget_test.dart:9:8 -
         uri_does_not_exist
warning - Unused import: 'package:ai_fitness_coach/main.dart' - test\widget_test.dart:11:8 - unused_import
         uri_does_not_exist
warning - Unused import: 'package:ai_fitness_coach/main.dart' - test\widget_test.dart:11:8 - unused_import
warning - Unused import: 'package:ai_fitness_coach/main.dart' - test\widget_test.dart:11:8 - unused_import
  error - The function 'testWidgets' isn't defined - test\widget_test.dart:14:3 - undefined_function
  error - Undefined class 'WidgetTester' - test\widget_test.dart:14:49 - undefined_class
  error - The name 'MyApp' isn't a class - test\widget_test.dart:16:35 - creation_with_non_type
  error - Undefined class 'WidgetTester' - test\widget_test.dart:14:49 - undefined_class
  error - The name 'MyApp' isn't a class - test\widget_test.dart:16:35 - creation_with_non_type
  error - The name 'MyApp' isn't a class - test\widget_test.dart:16:35 - creation_with_non_type
  error - The function 'expect' isn't defined - test\widget_test.dart:19:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:19:12 - undefined_identifier
  error - Undefined name 'findsOneWidget' - test\widget_test.dart:19:28 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:19:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:19:12 - undefined_identifier
  error - Undefined name 'findsOneWidget' - test\widget_test.dart:19:28 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:20:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:19:12 - undefined_identifier
  error - Undefined name 'findsOneWidget' - test\widget_test.dart:19:28 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:20:5 - undefined_function
  error - Undefined name 'findsOneWidget' - test\widget_test.dart:19:28 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:20:5 - undefined_function
  error - The function 'expect' isn't defined - test\widget_test.dart:20:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:20:12 - undefined_identifier
  error - Undefined name 'findsNothing' - test\widget_test.dart:20:28 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:23:22 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:20:12 - undefined_identifier
  error - Undefined name 'findsNothing' - test\widget_test.dart:20:28 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:23:22 - undefined_identifier
  error - Undefined name 'findsNothing' - test\widget_test.dart:20:28 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:23:22 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:23:22 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:27:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:27:12 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:27:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:27:12 - undefined_identifier
  error - Undefined name 'find' - test\widget_test.dart:27:12 - undefined_identifier
  error - Undefined name 'findsNothing' - test\widget_test.dart:27:28 - undefined_identifier
  error - Undefined name 'findsNothing' - test\widget_test.dart:27:28 - undefined_identifier
  error - The function 'expect' isn't defined - test\widget_test.dart:28:5 - undefined_function
  error - Undefined name 'find' - test\widget_test.dart:28:12 - undefined_identifier
  error - Undefined name 'findsOneWidget' - test\widget_test.dart:28:28 - undefined_identifier

58 issues found. (ran in 2.6s)