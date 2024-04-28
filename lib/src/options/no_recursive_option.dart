import 'package:dartmon_cli/src/models/option.dart';

class NoRecursiveOption extends Option {
  @override
  handler(String? value) {
    if (value != null) {
      config.nextArgumentIndex--;
    }
    config.recursive = false;
  }

  @override
  String get help => "Do not watch directories recursively.";

  @override
  List<String> get invocations => [
        '--no-recursive',
        '-nr',
      ];

  @override
  String get name => "no-recursive";

  @override
  String get usage =>
      "Usage: dartmon --no-recursive\n\nDo not watch directories recursively.\nNote: Watching directories recursively is not available on Linux Systems.";
}
