// part of 'config.dart';

// extension on DartmonConfig {
//   bool execHandler(String option, String? value) {
//     if (!(option == '--exec' || option == '-x')) return false;
//     if (value == null || value.isEmpty) throw "Argument for --exec is missing";
//     if (cmd != null) {
//       throw "Cannot set command multiple times, previosuly set to $cmd, now being set to $value";
//     }
//     if (args.isNotEmpty) {
//       throw "Cannot set arguments multiple times, previosuly set to $args, now being set to $value";
//     }
//     cmd = value.split(' ').first;
//     args = value.split(' ').sublist(1);
//     return true;
//   }

//   bool configHandler(String option, String? value) {
//     if (!(option == '--config' || option == '-c')) return false;
//     if (value == null) throw "Argument for --config is missing";
//     final file = File(value);
//     if (!file.existsSync()) throw "Config file not found at '$value'";
//     final json = jsonDecode(file.readAsStringSync());
//     loadFromJson(json);
//     return true;
//   }

//   bool recursiveHandler(String option, String? value) {
//     if (option == '--recursive' || option == '-r') {
//       recursive = true;
//     } else if (option == '--no-recursive' ||
//         option == '--non-recursive' ||
//         option == '-non-recursive' ||
//         option == '--not-recursive' ||
//         option == '-nr' ||
//         option == '-n-r') {
//       recursive = false;
//     } else {
//       return false;
//     }
//     return true;
//   }

//   bool watchHandler(String option, String? value) {
//     if (!(option == '--watch' || option == '-w')) return false;
//     if (value == null) throw "Argument for --watch is missing";
//     final paths = value.split(',');
//     for (final path in paths) {
//       final file = File(path);
//       final dir = Directory(path);
//       if (file.existsSync()) {
//         files.add(file);
//       } else if (dir.existsSync()) {
//         directories.add(dir);
//       } else {
//         throw "'$path' is neither a file nor a directory";
//       }
//     }
//     return true;
//   }

//   bool extHandler(String option, String? value) {
//     if (!(option == '--ext' || option == '-e')) return false;
//     if (value == null) throw "Argument for --ext is missing";
//     ext.addAll(value.split(',').map((e) => e.startsWith('.') ? e : '.$e'));
//     return true;
//   }

//   bool ignoreHandler(String option, String? value) {
//     if (!(option == '--ignore' || option == '-i')) return false;
//     if (value == null) throw "Argument for --ignore is missing";
//     final paths = value.split(',');
//     for (final path in paths) {
//       final file = File(path);
//       final dir = Directory(path);
//       if (file.existsSync()) {
//         ignoreFiles.add(file.path);
//       } else if (dir.existsSync()) {
//         ignoreDirectories.add(dir.path);
//       } else {
//         log("Ignoring '$path' which is neither a file nor a directory");
//       }
//     }
//     return true;
//   }

//   bool timeoutHandler(String option, String? value) {
//     if (!(option == '--timeout' || option == '-t')) return false;
//     if (value == null) throw "Argument for --timeout is missing";
//     if (timeout != null) {
//       throw "Cannot set timeout multiple times, previously set to $timeout, now being set to $value";
//     }
//     timeout = DurationExtension.tryParse(value);
//     if (timeout == null) {
//       throw "Invalid duration format for --timeout, given: $value";
//     }
//     return true;
//   }

//   bool helpHandler(String option, String? value) {
//     if (!(option == '--help' || option == '-h')) return false;
//     print("TODO: Show help message here");
//     exit(0);
//   }

//   bool versionHandler(String option, String? value) {
//     if (!(option == '--version' || option == '-v')) return false;
//     print("TODO: Show version here");
//     return true;
//   }

//   bool fileHandler(String option, String? value) {
//     if (!(option.contains('.'))) return false;
//     final extension = option.split('.').last;
//     switch (extension) {
//       case 'dart':
//         cmd = 'dart';
//         args = ['run', option];
//         break;
//       case 'py':
//         cmd = 'python';
//         args = [option];
//         break;
//       case 'js':
//         cmd = 'node';
//         args = [option];
//         break;
//       default:
//         throw "Unknown file extension: $extension";
//     }
//     ext.add('.$extension');
//     final file = File(option);
//     if (!file.existsSync()) throw "File not found at '$option'";
//     files.add(file);
//     return true;
//   }

//   bool handleDartArguments(List<String> arguments) {
//     cmd = 'dart';
//     args = arguments;
//     directories.add(Directory('lib'));
//     directories.add(Directory('bin'));
//     files.add(File('pubspec.yaml'));
//     return true;
//   }
// }
