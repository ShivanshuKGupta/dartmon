import 'dart:convert';
import 'dart:io';
import 'package:dartmon/src/config/config.dart';
import 'package:dartmon/src/services/process_service.dart';

/// this is the service we use to manage the process
/// Killing it, starting it, restarting it, etc.
class OtherProcessService extends ProcessService {
  OtherProcessService(DartmonConfig config)
      : super(config, 'OtherProcessService');

  /// This is used for debouncing the restart function
  /// In case, of multiple restart requests within [config.timeout],
  /// we only restart once
  int executionIndex = 0;

  @override
  Future<void> init() async {
    if (config.cmd == 'dart') {
      /// run with enabled vm service
      if (!config.args.contains('--enable-vm-service')) {
        config.args.add('--enable-vm-service');
      }
    }
  }

  @override
  Future<void> start() async {
    ++executionIndex;
    if (process != null) {
      logger.write('Stopping existing process...');

      /// The below stop will trigger the exitCode handler
      /// which in turns restarts the process
      stop();
      return;
    }

    /// Trying to start the process
    try {
      logger.write(
          'Starting process using, cmd = ${config.cmd}, args = ${config.args}');
      process = await Process.start(
        config.cmd!,
        config.args,
      );
      logger.write('Process Started successfully...');
    } catch (e) {
      print("Error starting process: \n$e");
      logger.write('Error starting process: \n$e');
      print("Press enter to restart...");
      return;
    }

    logger.write("Process Started successfully...");
    isRunning = true;

    /// We are just outputing the stdout and stderr of the process
    /// to the stdout of the parent process
    process!.stdout.transform(utf8.decoder).listen((data) {
      stdout.write(data);
    });
    process!.stderr.transform(utf8.decoder).listen((data) {
      stdout.write(data);
    });
    process!.exitCode.then((code) {
      process = null;
      if (isRunning) {
        /// If the process stopped on its own
        /// we will print the exit code and ask the user to restart
        print('Process exited with code $code');
        print("Press enter to restart...");
      } else {
        /// If the process stopped due to a restart
        /// we will restart the process
        start();
      }
    });
  }

  @override
  Future<void> stop() async {
    /// [isRunning] flag tells the service that the process was killed by the parent
    /// and not on its own
    isRunning = false;
    process?.kill();
  }

  @override
  Future<void> restart() async {
    int tmp = ++executionIndex;
    await Future.delayed(config.timeout!);

    /// If the executionIndex has changed, then another restart was requested
    /// within the timeout period, so we will let the other restart request
    /// handle the rest and return
    if (tmp != executionIndex) return;

    print('Restarting...');
    start();
  }
}
