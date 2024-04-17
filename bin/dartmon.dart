import 'dart:io';

import 'package:dartmon/dartmon.dart' as dartmon;

void main(List<String> arguments) async {
  final exitCode = dartmon.run(arguments);
  await Future.wait<void>([stdout.close(), stderr.close()]);
  exit(exitCode);
}
