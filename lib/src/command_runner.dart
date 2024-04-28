import 'dart:io';

import 'package:dartmon/src/config/config.dart';
import 'package:dartmon/src/options/version_option.dart';
import 'package:dartmon/src/services/logger.dart';
import 'package:dartmon/src/options/config_option.dart';
import 'package:dartmon/src/options/dart_command_option.dart';
import 'package:dartmon/src/options/exec_option.dart';
import 'package:dartmon/src/options/ext_option.dart';
import 'package:dartmon/src/options/file_option.dart';
import 'package:dartmon/src/options/help_option.dart';
import 'package:dartmon/src/options/ignore_option.dart';
import 'package:dartmon/src/options/no_recursive_option.dart';
import 'package:dartmon/src/options/timeout_option.dart';
import 'package:dartmon/src/options/watch_option.dart';
import 'package:dartmon/src/services/watcher.dart';

void run(List<String> arguments) {
  Logger("dartmon")
      .write("---------------------------------------------------------"
          "\nStarting dartmon time: ${DateTime.now()}");
  final config = DartmonConfig();
  config.addOption(ConfigOption());
  config.addOption(DartCommandOption());
  config.addOption(ExecOption());
  config.addOption(ExtOption());
  config.addOption(FileOption());
  config.addOption(HelpOption());
  config.addOption(IgnoreOption());
  config.addOption(NoRecursiveOption());
  config.addOption(TimeoutOption());
  config.addOption(VersionOption());
  config.addOption(WatchOption());

  try {
    config.construct(arguments);
  } catch (e) {
    print(e);
    exit(1);
  }

  final watcher = Watcher(config);
  watcher.start();
}
