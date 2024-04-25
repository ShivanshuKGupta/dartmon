import 'dart:io';

class Logger {
  static File? _file;
  final String name;

  Logger(this.name) {
    String executableDirectory = File(Platform.resolvedExecutable).parent.path;

    /// below log file is created in the directory of the executable
    _file ??= File('$executableDirectory/dartmon.log');

    print('Logging to: ${_file!.absolute.path}');
  }

  void write(dynamic message) {
    _file!.writeAsStringSync('$name: $message\n', mode: FileMode.append);
  }
}
