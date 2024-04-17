import 'package:dartmon/models/option.dart';

class ExecOption extends Option {
  @override
  handler(String? value) {
    if (value == null || value.isEmpty) throw "Argument for --exec is missing";
    if (config.cmd != null) {
      throw "Cannot set command multiple times, previosuly set to ${config.cmd}, now being set to $value";
    }
    if (config.args.isNotEmpty) {
      throw "Cannot set arguments multiple times, previosuly set to ${config.args}, now being set to $value";
    }
    config.cmd = value.split(' ').first;
    config.args = value.split(' ').sublist(1);
    return true;
  }

  @override
  String get help => "Execute the given command and restart on file changes.";

  @override
  List<String> get invocations => [
        '--exec',
        '-e',
      ];

  @override
  String get name => "exec";

  @override
  String get usage =>
      "Usage: dartmon --exec <command>\n\nExecute the given command.\n\nExample: dartmon --exec 'dart run test'\n\nYou can skip the inverted quotes if the command does not contain any spaces.";
}
