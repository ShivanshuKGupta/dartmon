import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartmon/action.dart';
import 'package:dartmon/duration_extension.dart';

part 'construct_config.g.dart';

class DartmonConfig {
  String? cmd;
  List<String> args = [];
  String get exec {
    if (args.isEmpty) return cmd!;
    return '$cmd ${args.join(' ')}';
  }

  List<Directory> directories = [];
  List<File> files = [];
  List<String> ext = []; // All extensions will start with a dot
  List<String> ignoreDirectories = [
    '.dart_tool',
    '.git',
    '.idea',
    '.vscode',
    'build',
    'packages',
    'pubspec.lock',
    'pubspec.yaml',
    'test',
    'node_modules',
    '__pycache__',
  ];
  List<String> ignoreFiles = [
    '.gitignore',
    '.gitkeep',
    '.packages',
    'pubspec.lock',
    'pubspec.yaml',
  ];
  Duration? timeout;
  bool recursive = true;
  List<DartmonAction> actions = [];

  DartmonConfig({
    this.cmd,
    List<String>? args,
    List<Directory>? directories,
    List<File>? files,
    List<String>? ext,
    List<String>? ignoreDirectories,
    List<String>? ignoreFiles,
    this.timeout,
    this.recursive = false,
    List<DartmonAction>? actions,
  }) {
    this.args = args ?? this.args;
    this.directories = directories ?? this.directories;
    this.files = files ?? this.files;
    this.ext = ext ?? this.ext;
    this.ignoreDirectories = ignoreDirectories ?? this.ignoreDirectories;
    this.ignoreFiles = ignoreFiles ?? this.ignoreFiles;
    this.actions = actions ?? this.actions;
  }

  DartmonConfig.fromJson(Map<String, dynamic> json) {
    loadFromJson(json);
  }

  void loadFromJson(Map<String, dynamic> json) {
    cmd = json['cmd'] ?? cmd;
    args = json['args'] != null ? List<String>.from(json['args']) : args;
    directories = json['directories'] != null
        ? List<String>.from(json['directories'])
            .map((e) => Directory(e))
            .toList()
        : directories;
    files = json['files'] != null
        ? List<String>.from(json['files']).map((e) => File(e)).toList()
        : files;
    ext = json['ext'] != null ? List<String>.from(json['ext']) : ext;
    ignoreDirectories = json['ignoreDirectories'] != null
        ? List<String>.from(json['ignoreDirectories'])
        : ignoreDirectories;
    ignoreFiles = json['ignoreFiles'] != null
        ? List<String>.from(json['ignoreFiles'])
        : ignoreFiles;
    timeout = DurationExtension.tryParse(json['timeout'].toString()) ?? timeout;
    recursive = json['recursive'] ?? recursive;
    actions = json['actions'] != null
        ? List<DartmonAction>.from(json['actions'])
        : actions;
  }

  Map<String, dynamic> toJson() {
    return {
      'cmd': cmd,
      'args': args,
      'directories': directories.map((e) => e.path).toList(),
      'files': files.map((e) => e.path).toList(),
      'ext': ext,
      'ignoreDirectories': ignoreDirectories,
      'ignoreFiles': ignoreFiles,
      'timeout': timeout?.toUnitString(),
      'recursive': recursive,
      'actions': actions,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  void construct(List<String> args) {
    if (args.isEmpty) {
      helpHandler("-h", null);
      exit(0);
    }
    for (int i = 0; i < args.length; ++i) {
      String option = args[i];
      String? value;
      if (args.length > i + 1 && !args[i + 1].startsWith('-')) {
        i++;
        value = args[i];
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        } else if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        }
        value = value.trim();
        value = value.replaceAll(RegExp(r'\s{2,}'), ' ');
      }
      bool handled = false;
      handled = handled || helpHandler(option, value);
      handled = handled || versionHandler(option, value);
      handled = handled || execHandler(option, value);
      handled = handled || recursiveHandler(option, value);
      handled = handled || watchHandler(option, value);
      handled = handled || extHandler(option, value);
      handled = handled || ignoreHandler(option, value);
      handled = handled || timeoutHandler(option, value);
      handled = handled || fileHandler(option, value);
      handled = handled || configHandler(option, value);

      if (!handled) {
        handleDartArguments(args.sublist(i));
        break;
      }
    }
    timeout ??= Duration(seconds: 1);
    if (cmd == null) throw "Nothing to run!";

    /// Making sure the directories are absolute
    ignoreDirectories = ignoreDirectories.map((e) {
      return Directory(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();

    /// Making sure the files are absolute
    ignoreFiles = ignoreFiles.map((e) {
      return File(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();
  }
}
