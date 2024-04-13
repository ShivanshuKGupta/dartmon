import 'dart:convert';
import 'dart:io';
import 'package:dartmon/config.dart';

class ProcessService {
  Process? process;
  bool isRunning = false;
  DartmonConfig config;
  int executionIndex = 0;

  ProcessService(this.config) {
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

  Future<void> start() async {
    ++executionIndex;
    stop();
    while (process != null) {
      await Future.delayed(config.timeout!);
    }
    process = await Process.start(
      config.cmd!,
      config.args,
    );
    isRunning = true;
    process!.stdout.transform(utf8.decoder).listen((data) {
      print(data);
    });
    process!.stderr.transform(utf8.decoder).listen((data) {
      print(data);
    });
    process!.exitCode.then((code) {
      if (isRunning) {
        print('Process exited with code $code');
        print("Press any key to restart...");
      }
      process = null;
    });
  }

  void stop() {
    process?.kill();
    isRunning = false;
  }

  void restart(Duration timeout) async {
    int tmp = ++executionIndex;
    await Future.delayed(timeout);
    if (tmp != executionIndex) return;
    print('Restarting...');
    start();
  }

  void onStdinEvent(data) {
    if (!isRunning || process == null) {
      restart(Duration(seconds: 0));
      return;
    }
    process!.stdin.writeln(data);
  }
}
