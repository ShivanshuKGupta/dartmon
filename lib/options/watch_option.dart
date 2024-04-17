import 'dart:io';

import 'package:dartmon/option.dart';

class WatchOption extends Option {
  @override
  handler(String? value) {
    if (value == null) throw "Argument for --watch is missing";
    final paths = value.split(',');
    for (final path in paths) {
      final file = File(path);
      final dir = Directory(path);
      if (file.existsSync()) {
        config.files.add(file);
      } else if (dir.existsSync()) {
        config.directories.add(dir);
      } else {
        throw "'$path' is neither a file nor a directory";
      }
    }
  }

  @override
  String get help => "Watch the given files and directories for changes.";

  @override
  List<String> get invocations => [
        '--watch',
        '-w',
      ];

  @override
  String get name => "watch";

  @override
  String get usage =>
      "Usage: dartmon --watch <file1>,<file2>,<dir1>,<dir2>\n\nWatch the given files and directories for changes.\n\nExample: dartmon --watch lib --watch test\n\nNote: You can watch multiple files and directories by separating them with a comma.\nLike this: dartmon --watch lib,test,example";
}
