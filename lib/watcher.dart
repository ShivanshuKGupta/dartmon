import 'dart:io';

import 'package:dartmon/config.dart';
import 'package:dartmon/process_service.dart';

class Watcher {
  final DartmonConfig config;

  Watcher(this.config) {
    ProcessService.init(config);
  }

  Future<void> start() async {
    final filesToWatch = config.files;
    final dirsToWatch = config.directories;
    if (dirsToWatch.isEmpty) {
      dirsToWatch.add(Directory('.'));
    }
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
    for (int i = 0; i < filesToWatch.length; i++) {
      filesToWatch[i].watch(events: FileSystemEvent.all).listen(onFileModify);
    }
    for (int i = 0; i < dirsToWatch.length; i++) {
      dirsToWatch[i]
          .watch(events: FileSystemEvent.all, recursive: config.recursive)
          .listen(onFileModify);
    }
    print('Starting: \'${config.exec}\'...');
    await ProcessService.start();
  }

  Future<void> onFileModify(FileSystemEvent event) async {
    if (event.isDirectory) return;
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
    ProcessService.restart(config.timeout!);
  }
}
