import 'dart:io';

import 'package:dartmon/option.dart';

class HelpOption extends Option<bool> {
  HelpOption() : super();

  @override
  String get help => 'Print this usage information.';

  @override
  get name => 'help';

  @override
  get invocations => ['--$name', '-h'];

  @override
  get usage => 'Usage: dartmon help <command>';

  @override
  bool handler(String? value) {
    if (config.nextArgumentIndex >= config.arguments.length) {
      print(
          "A command-line utility for Dart that automatically restarts your app when files change.");
      print("\nUsage: dartmon <command|dart-file> [arguments]");
      print("\nGlobal options:");
      for (final option in config.options) {
        bool isAGlobalOption = false;
        for (final invocation in option.invocations) {
          if (invocation.startsWith('-')) {
            isAGlobalOption = true;
            break;
          }
        }
        if (isAGlobalOption) {
          print("  ${option.invocations.join(' ')}\t${option.help}");
        }
      }
      print("\nAvailable Commands:");
      for (final option in config.options) {
        bool isAGlobalOption = false;
        for (final invocation in option.invocations) {
          if (invocation.startsWith('-')) {
            isAGlobalOption = true;
            break;
          }
        }
        if (!isAGlobalOption) {
          print("  ${option.invocations.join(' ')}\t${option.help}");
        }
      }
      print(
          "\nRun 'dartmon --help <command>' for more information about a command.");
    } else {
      value = config.arguments[config.nextArgumentIndex];
      final command = config.options.firstWhere(
          (element) => element.invocations.contains(value),
          orElse: () => throw 'Command not found');
      print(command.usage);
    }
    exit(0);
  }
}
