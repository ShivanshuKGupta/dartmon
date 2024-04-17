import 'package:dartmon/config.dart';
import 'package:dartmon/options/config_option.dart';
import 'package:dartmon/options/dart_command_option.dart';
import 'package:dartmon/options/exec_option.dart';
import 'package:dartmon/options/ext_option.dart';
import 'package:dartmon/options/file_option.dart';
import 'package:dartmon/options/help_option.dart';
import 'package:dartmon/options/ignore_option.dart';
import 'package:dartmon/options/no_recursive_option.dart';
import 'package:dartmon/options/timeout_option.dart';
import 'package:dartmon/options/version_option.dart';
import 'package:dartmon/options/watch_option.dart';
import 'package:dartmon/process_service.dart';
import 'package:dartmon/watcher.dart';

int run(List<String> arguments) {
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
    return 1;
  }

  final watcher = Watcher(config);
  watcher.start();
  return 0;
}
