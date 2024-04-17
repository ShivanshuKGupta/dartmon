import 'dart:convert';
import 'dart:io';
import 'package:dartmon/config/config.dart';
import 'package:dartmon/services/logger.dart';

/// this is the service we use to manage the process
/// Killing it, starting it, restarting it, etc.
class ProcessService {
  ProcessService._();

  /// the process that we are managing
  static Process? process;

  /// a flag to check if the process is or was running
  static bool isRunning = false;

  /// we use it to get the command and the arguments of the process
  static late final DartmonConfig config;

  /// This is used for debouncing the restart function
  /// In case, of multiple restart requests within [config.timeout],
  /// we only restart once
  static int executionIndex = 0;

  /// the logger instance for the ProcessService
  static final Logger _logger = Logger('ProcessService');

  /// this function is used to initialize the ProcessService
  /// with the config.
  ///
  /// It also adds listeners to the stdin and the sigint signal
  static void init(DartmonConfig config) {
    _logger.write('Initializing ProcessService');
    ProcessService.config = config;
    _logger.write('Adding Listeners...');
    stdin.listen(_onStdinEvent);

    /// Below we are adding listeners to the sigint and sigterm signals
    /// to stop the process when the user presses ctrl+c
    /// or when the process is killed by the system
    ///
    /// or else the process will keep running in the background
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

  /// this function is used to start the process
  static Future<void> start() async {
    ++executionIndex;
    if (process != null) {
      _logger.write('Stopping existing process...');

      /// The below stop will trigger the exitCode handler
      /// which in turns restarts the process
      stop();
      return;
    }

    /// Trying to start the process
    try {
      _logger.write(
          'Starting process using, cmd = ${config.cmd}, args = ${config.args}');
      process = await Process.start(
        config.cmd!,
        config.args,
      );
      _logger.write('Process Started successfully...');
    } catch (e) {
      print("Error starting process: \n$e");
      _logger.write('Error starting process: \n$e');
      print("Press enter to restart...");
      return;
    }

    _logger.write("Process Started successfully...");
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

  /// this function is used to stop the process
  static void stop() {
    /// [isRunning] flag tells the service that the process was killed by the parent
    /// and not on its own
    isRunning = false;
    process?.kill();
  }

  static void restart(Duration timeout) async {
    int tmp = ++executionIndex;
    await Future.delayed(timeout);

    /// If the executionIndex has changed, then another restart was requested
    /// within the timeout period, so we will let the other restart request
    /// handle the rest and return
    if (tmp != executionIndex) return;

    print('Restarting...');
    start();
  }

  static void _onStdinEvent(data) {
    if (!isRunning || process == null) {
      /// On any key event, if the process is not running
      /// we will start the process again
      start();
      return;
    }

    /// else we will pass whatever we got to the child process
    process?.stdin.writeln(data);
  }
}
