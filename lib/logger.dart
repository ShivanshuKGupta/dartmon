import 'dart:io';

class Logger {
  static File? _file;
  final String name;

  Logger(this.name) {
    _file ??= File('dartmon_logs.txt');
  }

  void write(dynamic message) {
    _file!.writeAsStringSync('$name: $message\n', mode: FileMode.append);
  }
}
