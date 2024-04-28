import 'dart:async';
import 'dart:io';

import 'package:dartmon/src/config/config.dart';
import 'package:dartmon/src/services/other_process_service.dart';
import 'package:dartmon/src/services/process_service.dart';

/// The watcher class is responsible for watching the files and directories
/// And restarting the process when a file is modified
///
/// Here, we apply checks for ignore directories and files
class Watcher {
  final DartmonConfig config;
  late final ProcessService process;

  Watcher(this.config);

  Future<void> start() async {
    /// Determining which type of process to run
    process = OtherProcessService(config);
    await process.init();

    /// for dart processes, we let the vm service handle the hot reloading
    if (process is OtherProcessService) {
      /// If the process is not a dart process, we manually watch all the files
      final filesToWatch = config.files;
      final dirsToWatch = config.directories;
      if (dirsToWatch.isEmpty) {
        dirsToWatch.add(Directory('.'));
      }

      /// We first find all files with the given extensions
      /// and add them to the filesToWatch list
      ///
      /// Note: we only find files in the directories to watch
      if (config.ext.isNotEmpty) {
        print('Finding files with extensions: ${config.ext}');
        for (var dir in dirsToWatch) {
          final entities = dir.listSync(recursive: true);
          for (var entity in entities) {
            if (entity is File) {
              if (config.ext.contains(entity.path.split('.').last)) {
                filesToWatch.add(entity);
              }
            }
          }
        }
      }

      /// Adding listeners to the files and directories changes
      for (int i = 0; i < filesToWatch.length; i++) {
        filesToWatch[i].watch(events: FileSystemEvent.all).listen(onFileModify);
      }
      for (int i = 0; i < dirsToWatch.length; i++) {
        dirsToWatch[i]
            .watch(events: FileSystemEvent.all, recursive: config.recursive)
            .listen(onFileModify);
      }
      print('Starting: \'${config.exec}\'...');
    } else {
      print('Starting Dart Process: \'${config.exec}\'...');
    }

    /// After all the preparation, we start the process
    await process.start();
  }

  Future<void> onFileModify(FileSystemEvent event) async {
    if (event.isDirectory) return;

    /// We ignore the files and directories that are in the ignore list
    ///
    /// Note: for comparing we first made all the paths lowercase, replaced all
    /// the backslashes with forward slashes and then compared.
    ///
    /// We did a similar thing in the [config.construct] method
    final path =
        File(event.path).absolute.path.toLowerCase().replaceAll('\\', '/');
    String dir =
        path.split('/').sublist(0, path.split('/').length - 1).join('/');
    if (config.ignoreFiles.contains(path) ||
        config.ignoreDirectories.contains(dir)) {
      print('Ignoring file: ${event.path}');
      return;
    }
    if (event.type == FileSystemEvent.modify) {
      print('File modified: ${event.path}');
    } else if (event.type == FileSystemEvent.create) {
      print('File created: ${event.path}');
    } else if (event.type == FileSystemEvent.delete) {
      print('File deleted: ${event.path}');
    } else if (event.type == FileSystemEvent.move) {
      print('File moved: ${event.path}');
    }
    process.restart();
  }
}
