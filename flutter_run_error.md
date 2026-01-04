lib/main.dart:139:28: Error: Can't find ')' to match '('.
        return _createRoute(
                           ^
lib/services/program_service.dart:3:8: Error: Error when reading 'lib/data/program_templates.dart': The system cannot find the file specified.      

import '../data/program_templates.dart';
       ^
lib/main.dart:153:7: Error: 'default' can't be used as an identifier because it's a keyword.
Try renaming this to be an identifier that isn't a keyword.
      default:
      ^^^^^^^
lib/main.dart:154:9: Error: Unexpected token 'return'.
        return null;
        ^^^^^^
lib/main.dart:153:7: Error: No named parameter with the name 'default'.
      default:
      ^^^^^^^
lib/services/program_service.dart:17:12: Error: The getter 'ProgramTemplates' isn't defined for the class 'ProgramService'.
 - 'ProgramService' is from 'package:ai_fitness_coach/services/program_service.dart' ('lib/services/program_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'ProgramTemplates'.
    return ProgramTemplates.getAllTemplates();
           ^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
