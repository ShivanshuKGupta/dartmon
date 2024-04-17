import 'dart:convert';
import 'dart:io';
import 'package:dartmon/config/config.dart';
import 'package:dartmon/services/logger.dart';

class ProcessService {
  ProcessService._();

  static Process? process;
  static bool isRunning = false;
  static late final DartmonConfig config;
  static int executionIndex = 0;
  static final Logger _logger = Logger('ProcessService');

  static void init(DartmonConfig config) {
    _logger.write('Initializing ProcessService');
    ProcessService.config = config;
    _logger.write('Adding Listeners...');
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
    _logger.write('ProcessService Initialized');
  }

  static Future<void> start() async {
    ++executionIndex;
    if (process != null) {
      _logger.write('Stopping existing process...');
      stop();
      return;
    }
    try {
      _logger.write(
          'Starting process using, cmd = ${config.cmd}, args = ${config.args}');
      process = await Process.start(
        config.cmd!,
        config.args,
      );
      _logger.write('Process Started successfully...');
    } catch (e) {
      print("Error starting process: $e");
      _logger.write('Error starting process: $e');
      return;
    }
    _logger.write("Process Started successfully...");
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
