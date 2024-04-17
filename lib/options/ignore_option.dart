import 'dart:io';

import 'package:dartmon/option.dart';

class IgnoreOption extends Option {
  @override
  handler(String? value) {
    if (value == null) throw "Argument for --ignore is missing";
    final paths = value.split(',');
    for (final path in paths) {
      final file = File(path);
      final dir = Directory(path);
      if (file.existsSync()) {
        config.ignoreFiles.add(file.path);
      } else if (dir.existsSync()) {
        config.ignoreDirectories.add(dir.path);
      } else {
        print("Ignoring '$path' which is neither a file nor a directory");
      }
    }
  }

  @override
  String get help => "Ignore the given files and directories.";

  @override
  List<String> get invocations => [
        '--ignore',
        '-i',
      ];

  @override
  String get name => "ignore";

  @override
  String get usage =>
      "Usage: dartmon --ignore <file1>,<file2>,<dir1>,<dir2>\n\nIgnore the given files and directories.\n\nExample: dartmon --ignore lib --ignore test\n\nNote: You can ignore multiple files and directories by separating them with a comma.\nLike this: dartmon --ignore lib,test,example";
}
