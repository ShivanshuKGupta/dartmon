import 'dart:io';

import 'package:dartmon/src/models/unknown_option.dart';

class DartCommandOption extends UnknownOption {
  @override
  bool handler(String? value) {
    if (value != null) {
      print("value wasn't null in DartCommandOption handler: value = $value");
    }
    config.cmd = 'dart';
    config.args = config.arguments.sublist(config.nextArgumentIndex);
    config.directories.add(Directory('lib'));
    config.directories.add(Directory('bin'));
    config.files.add(File('pubspec.yaml'));
    return true;
  }

  @override
  String get help => 'You can run any dart command using dartmon.';

  @override
  String get name => "dart";

  @override
  String get usage =>
      'Usage: dartmon <dart commands>\nExample: dartmon run main.dart args_for_main_dart\nRuns the Dart command with the all the following arguments passed to it';
}
