import 'dart:io';

import 'package:dartmon_cli/src/models/option.dart';
import 'package:dartmon_cli/src/version.dart';

class VersionOption extends Option {
  @override
  handler(String? value) {
    print("dartmon version: $version");
    exit(0);
  }

  @override
  String get help => "Print the version of dartmon.";

  @override
  List<String> get invocations => [
        '--version',
        '-v',
      ];

  @override
  String get name => "version";

  @override
  String get usage =>
      "Usage: dartmon --version\n\nPrint the version of dartmon.";
}
