import 'dart:io';

import 'package:dartmon/unknown_option.dart';

class FileOption extends UnknownOption {
  @override
  bool handler(String? value) {
    if (value == null) return false;
    if (!(value.contains('.'))) return false;
    if (config.cmd != null) {
      throw "Cannot set file multiple times, previously set to ${config.args.lastOrNull ?? (config.cmd! + config.args.join(' '))}, now being set to $value";
    }
    final extension = value.split('.').last;
    switch (extension) {
      case 'dart':
        config.cmd = 'dart';
        config.args = ['run', value];
        break;
      case 'py':
        config.cmd = 'python';
        config.args = [value];
        break;
      case 'js':
        config.cmd = 'node';
        config.args = [value];
        break;
      default:
        throw "Unknown file extension: $extension";
    }
    config.ext.add('.$extension');
    final file = File(value);
    if (!file.existsSync()) throw "File not found at '$value'";
    config.files.add(file);
    return true;
  }

  @override
  String get help => 'The file to run';

  @override
  String get name => 'file';

  @override
  String get usage =>
      'Usage: dartmon <file>\n\nExample: dartmon main.dart\n\nSupported extensions: .dart, .py, .js\n\nRuns the file with the appropriate command';
}
