import 'dart:convert';
import 'dart:io';

import 'package:dartmon/models/option.dart';

class ConfigOption extends Option<bool> {
  @override
  handler(String? value) {
    if (value == null) throw "Argument for --config is missing";
    final file = File(value);
    if (!file.existsSync()) throw "Config file not found at '$value'";
    final json = jsonDecode(file.readAsStringSync());
    config.loadFromJson(json);
    return true;
  }

  @override
  String get help => "Load configuration from a JSON file.";

  @override
  List<String> get invocations => [
        '--config',
        '-c',
      ];

  @override
  String get name => "config";

  @override
  String get usage =>
      "Usage: dartmon --config <file>\n\nLoad configuration from a JSON file.\n\nExample: dartmon --config dartmon.json";
}
