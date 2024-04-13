import 'dart:io';

import 'package:dartmon/config.dart';
import 'package:dartmon/watcher.dart';

void run(List<String> arguments) {
  final config = DartmonConfig();
  try {
    config.construct(arguments);
  } catch (e) {
    print(e);
    exit(1);
  }
  final watcher = Watcher(config);
  watcher.start();
}
