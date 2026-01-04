Warning: SDK processing. This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered. This can happen if you use versions of Android Studio and the command-line tools that were released at different times.
lib/services/program_service.dart:3:8: Error: Error when reading 'lib/data/program_templates.dart': The system cannot find the file specified.      

import '../data/program_templates.dart';
       ^
lib/services/program_service.dart:17:12: Error: The getter 'ProgramTemplates' isn't defined for the class 'ProgramService'.
 - 'ProgramService' is from 'package:ai_fitness_coach/services/program_service.dart' ('lib/services/program_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'ProgramTemplates'.
    return ProgramTemplates.getAllTemplates();
           ^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
