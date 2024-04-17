import 'dart:io';

import 'package:dartmon/models/unknown_option.dart';

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
  String get help => 'The Dart command to run';

  @override
  String get name => "dart";

  @override
  String get usage =>
      'Usage: dartmon <dart commands>\n\nExample: dartmon run main.dart\n\nRuns the Dart command with the all the following arguments passed to it';
}
