import 'dart:io';

import 'package:dartmon/src/options/help_option.dart';
import 'package:dartmon/src/services/logger.dart';
import 'package:dartmon/src/models/option.dart';
import 'package:dartmon/src/extensions/duration_extension.dart';
import 'package:dartmon/src/models/unknown_option.dart';

part 'construct_config.g.dart';

/// The configuration for the dartmon
/// This class is responsible for holding the configuration for the dartmon
/// What to run? What to watch? What to ignore? etc.
class DartmonConfig {
  /// The command to be executed
  String? cmd;

  /// The arguments to be passed to the command
  List<String> args = [];

  /// Get the command to be executed along with the arguments
  String get exec {
    if (args.isEmpty) return cmd!;
    return '$cmd ${args.join(' ')}';
  }

  /// The directories to watch
  List<Directory> directories = [];

  /// The files to watch
  List<File> files = [];

  /// The file extensions to watch, all extensions will have a leading dot
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
  /// An option may choose to parse multiple arguments or none
  /// and thus can make use of this index to parse the next argument
  /// or decrement the index to parse none arguments
  int nextArgumentIndex = 0;

  /// The [Logger] instance, which is used to log the messages in a file 'dartmon.log'
  final Logger _logger = Logger('DartmonConfig');

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

  /// Adds an option to the config instance
  /// These options are then later used to parse the command line arguments
  void addOption(Option option) {
    option.config = this;
    if (option is UnknownOption) {
      _logger.write("Adding an unknown option: $option");
      unknownOptions.add(option);
    } else {
      _logger.write("Adding an option: $option");
      options.add(option);
    }
  }

  /// Constructs the config instance using the command line arguments
  void construct(List<String> arguments) {
    return constructUsingArguments(arguments);
  }
}
