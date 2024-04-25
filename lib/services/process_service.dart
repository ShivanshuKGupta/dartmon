import 'dart:io';

import 'package:dartmon/config/config.dart';
import 'package:dartmon/services/logger.dart';

abstract class ProcessService {
  final DartmonConfig config;
  Process? process;
  late final Logger logger;
  bool isRunning = false;
  final Stream<ProcessSignal> sigintSignals = ProcessSignal.sigint.watch();
  Stream<ProcessSignal>? sigtermSignals;

  ProcessService(
    this.config, [
    String logName = 'ProcessService',
  ]) {
    logger = Logger(logName);
    logger.write('Adding Listeners...');
    stdin.listen(onStdinEvent);

    /// Below we are adding listeners to the sigint and sigterm signals
    /// to stop the process when the user presses ctrl+c
    /// or when the process is killed by the system
    ///
    /// or else the process will keep running in the background
    sigintSignals.listen(onAbortSignal);
    if (!Platform.isWindows) {
      sigtermSignals = ProcessSignal.sigterm.watch();
      sigtermSignals!.listen(onAbortSignal);
    }
    logger.write('ProcessService Initialized');
  }

  /// this function is used to start the process
  Future<void> start();

  /// this function is used to stop the process
  Future<void> stop();

  /// this function is used to restart the process
  Future<void> restart();

  /// this function is used to restart the process
  void onStdinEvent(data) {
    if (!isRunning || process == null) {
      /// On any key event, if the process is not running
      /// we will start the process again
      start();
      return;
    }

    /// else we will pass whatever we got to the child process
    process?.stdin.writeln(data);
  }

  void onAbortSignal(ProcessSignal event) {
    stop();
    exit(0);
  }

  dispose() {
    stop();
    sigintSignals.listen(null);
    sigtermSignals?.listen(null);
    stdin.listen(null);
  }
}
