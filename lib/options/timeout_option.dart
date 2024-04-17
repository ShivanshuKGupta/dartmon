import 'package:dartmon/option.dart';
import 'package:dartmon/duration_extension.dart';

class TimeoutOption extends Option {
  @override
  handler(String? value) {
    if (value == null) throw "Argument for --timeout is missing";
    if (config.timeout != null) {
      throw "Cannot set timeout multiple times, previously set to ${config.timeout}, now being set to $value";
    }
    config.timeout = DurationExtension.tryParse(value);
    if (config.timeout == null) {
      throw "Invalid duration format for --timeout, given: $value";
    }
  }

  @override
  String get help => "Set the timeout for the command.";

  @override
  List<String> get invocations => [
        '--timeout',
        '-t',
      ];

  @override
  String get name => "timeout";

  @override
  String get usage =>
      "Usage: dartmon --timeout <duration>\n\nSet the time to wait before restarting after a file change.\n\nExample: dartmon --timeout 5s\n\nNote: The duration format is <number><unit> where unit can be one of the following:\n\n- s, sec, secs, second, seconds (for seconds)\n- ms, msec, msecs, millisecond, milliseconds: (for milliseconds)\n\nExample: 1s, 100ms, 1000ms\n\nNote: Default unit is sec.";
}
