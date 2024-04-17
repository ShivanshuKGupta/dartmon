import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartmon/option.dart';
import 'package:dartmon/duration_extension.dart';
import 'package:dartmon/options/help_option.dart';
import 'package:dartmon/unknown_option.dart';

// part 'construct_config.g.dart';

class DartmonConfig {
  /// The command to be executed
  String? cmd;

  /// The arguments to be passed to the command
  List<String> args = [];

  /// The command to be executed along with the arguments
  String get exec {
    if (args.isEmpty) return cmd!;
    return '$cmd ${args.join(' ')}';
  }

  /// The directories to watch
  List<Directory> directories = [];

  /// The files to watch
  List<File> files = [];

  /// The extensions to watch, all extensions will have a leading dot
  List<String> ext = [];

  /// The directories to ignore
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

  /// The files to ignore
  List<String> ignoreFiles = [
    '.gitignore',
    '.gitkeep',
    '.packages',
    'pubspec.lock',
    'pubspec.yaml',
  ];

  /// The timeout for the command to run
  Duration? timeout;

  /// Whether to watch the directories recursively
  bool recursive = true;

  /// The options to be added to the command line arguments
  List<Option> options = [];

  /// The options which are to be applied on unknown arguments
  List<UnknownOption> unknownOptions = [];

  /// the whole command line arguments given to the dartmon
  List<String> arguments = [];

  /// The current argument index which is being parsed
  /// An option may choose to parse multiple arguments
  /// and thus can make use of this index to parse the next argument
  int currentArgumentIndex = 0;

  DartmonConfig({
    this.cmd,
    List<String>? args,
    List<Directory>? directories,
    List<File>? files,
    List<String>? ext,
    List<String>? ignoreDirectories,
    List<String>? ignoreFiles,
    this.timeout,
    this.recursive = true,
  }) {
    this.args = args ?? this.args;
    this.directories = directories ?? this.directories;
    this.files = files ?? this.files;
    this.ext = ext ?? this.ext;
    this.ignoreDirectories = ignoreDirectories ?? this.ignoreDirectories;
    this.ignoreFiles = ignoreFiles ?? this.ignoreFiles;
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
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  void addOption(Option option) {
    option.config = this;
    if (option is UnknownOption) {
      unknownOptions.add(option);
    } else {
      options.add(option);
    }
  }

  void construct(List<String> arguments) {
    this.arguments = arguments;
    if (arguments.isEmpty) {
      options.firstWhere((element) => element is HelpOption).handler(null);
      exit(0);
    }
    for (currentArgumentIndex = 0;
        currentArgumentIndex < arguments.length;
        ++currentArgumentIndex) {
      String option = arguments[currentArgumentIndex];
      String? value;
      if (arguments.length > currentArgumentIndex + 1 &&
          !arguments[currentArgumentIndex + 1].startsWith('-')) {
        currentArgumentIndex++;
        value = arguments[currentArgumentIndex];
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        } else if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        }
        value = value.trim();
        value = value.replaceAll(RegExp(r'\s{2,}'), ' ');
      }

      bool handled = false;
      for (int i = 0; i < options.length; i++) {
        if (options[i].invocations.contains(option)) {
          options[i].handler(value);
          handled = true;
          break;
        }
      }

      if (!handled) {
        for (int i = 0; i < unknownOptions.length; i++) {
          handled = handled || unknownOptions[i].handler(value);
          if (handled) break;
        }
      }

      if (!handled) {
        throw "Unknown option: $option";
      }
    }

    /// Defaults
    timeout ??= Duration(seconds: 1);

    /// Checks
    if (cmd == null) throw "Nothing to run!";

    // Making sure the directories are absolute
    ignoreDirectories = ignoreDirectories.map((e) {
      return Directory(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();

    /// Making sure the files are absolute
    ignoreFiles = ignoreFiles.map((e) {
      return File(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();
  }
}
