import 'dart:io';

import 'package:dartmon/models/unknown_option.dart';

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
  String get help =>
      'You can run a file using dartmon just like you would using dart.';

  @override
  String get name => 'file';

  @override
  String get usage =>
      'Usage: dartmon <file>\nExample: dartmon main.dart\nSupported extensions for files: .dart, .py, .js\nIt runs .dart files with dart, .py files with python, and .js files with node.';
}
