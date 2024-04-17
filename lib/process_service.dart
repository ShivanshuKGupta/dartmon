import 'dart:convert';
import 'dart:io';
import 'package:dartmon/config.dart';

class ProcessService {
  ProcessService._();

  static Process? process;
  static bool isRunning = false;
  static late final DartmonConfig config;
  static int executionIndex = 0;

  static void init(DartmonConfig config) {
    ProcessService.config = config;
    stdin.listen(onStdinEvent);
    ProcessSignal.sigint.watch().listen((signal) {
      stop();
      exit(0);
    });
    if (!Platform.isWindows) {
      ProcessSignal.sigterm.watch().listen((signal) {
        stop();
        exit(0);
      });
    }
  }

  static Future<void> start() async {
    ++executionIndex;
    if (process != null) {
      stop();
      return;
    }
    try {
      process = await Process.start(
        config.cmd!,
        config.args,
      );
    } catch (e) {
      print("Error starting process: $e");
      return;
    }
    isRunning = true;
    process!.stdout.transform(utf8.decoder).listen((data) {
      stdout.write(data);
    });
    process!.stderr.transform(utf8.decoder).listen((data) {
      stdout.write(data);
    });
    process!.exitCode.then((code) {
      process = null;
      if (isRunning) {
        // Process stopped on its own
        print('Process exited with code $code');
        print("Press enter to restart...");
      } else {
        // Process stopped due to a restart
        start();
      }
    });
  }

  static void stop() {
    isRunning = false;
    process?.kill();
  }

  static void restart(Duration timeout) async {
    int tmp = ++executionIndex;
    await Future.delayed(timeout);
    if (tmp != executionIndex) return;
    print('Restarting...');
    start();
  }

  static void onStdinEvent(data) {
    if (!isRunning || process == null) {
      start();
      return;
    }
    process?.stdin.writeln(data);
  }
}
