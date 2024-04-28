import 'dart:io';

import 'package:dartmon/src/models/option.dart';

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
    if (value == null &&
        config.nextArgumentIndex + 1 >= config.arguments.length) {
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
      bool commandFound = false;
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
          commandFound = true;
          print("  ${option.invocations.join(' ')}\t${option.help}");
        }
      }
      if (!commandFound) {
        print("  No commands found.");
      }
      print("\nOther functionalities:");
      for (final option in config.unknownOptions) {
        print("\n${option.help}\n${option.usage}");
      }
      print(
          "\nRun 'dartmon --help <command>' for more information about a command.");
    } else {
      value ??= config.arguments[config.nextArgumentIndex + 1];
      final command = config.options.firstWhere(
          (element) => element.invocations.contains(value),
          orElse: () =>
              throw 'Neither a Command nor a Global Option was found for \'$value\'');
      print(command.usage);
    }
    exit(0);
  }
}
