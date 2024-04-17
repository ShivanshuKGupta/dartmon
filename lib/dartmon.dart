import 'dart:io';

import 'package:dartmon/config/config.dart';
import 'package:dartmon/services/logger.dart';
import 'package:dartmon/options/config_option.dart';
import 'package:dartmon/options/dart_command_option.dart';
import 'package:dartmon/options/exec_option.dart';
import 'package:dartmon/options/ext_option.dart';
import 'package:dartmon/options/file_option.dart';
import 'package:dartmon/options/help_option.dart';
import 'package:dartmon/options/ignore_option.dart';
import 'package:dartmon/options/no_recursive_option.dart';
import 'package:dartmon/options/timeout_option.dart';
import 'package:dartmon/options/watch_option.dart';
import 'package:dartmon/services/watcher.dart';

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
  // config.addOption(VersionOption());
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
