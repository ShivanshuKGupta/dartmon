# Dartmon

A simple file watcher for Dart Projects. Can also be used to watch any other file types, or applications.

# Installing

```sh
# Activate Dartmon cli
dart pub global activate dartmon_cli

# See list of available commands
dartmon --help
```

# Help

```
A command-line utility for Dart that automatically restarts your app when files change.

Usage: dartmon <command|dart-file> [arguments]

Global options:
  --config -c   Load configuration from a JSON file.
  --exec -e     Execute the given command and restart on file changes.        
  --ext -x      Watch files with the given extensions only.
  --help -h     Print this usage information.
  --ignore -i   Ignore the given files and directories.
  --no-recursive -nr    Do not watch directories recursively.
  --timeout -t  Set the timeout for the command.
  --version -v  Print the version of dartmon.
  --watch -w    Watch the given files and directories for changes.

Available Commands:
  No commands found.

Other functionalities:

You can run any dart command using dartmon.
Usage: dartmon <dart commands>
Example: dartmon run main.dart args_for_main_dart
Runs the Dart command with the all the following arguments passed to it       

You can run a file using dartmon just like you would using dart.
Usage: dartmon <file>
Example: dartmon main.dart
Supported extensions for files: .dart, .py, .js
It runs .dart files with dart, .py files with python, and .js files with node.

Run 'dartmon --help <command>' for more information about a command.
```

## Upcoming Features

1. For dart projects, dartmon will use Dart's VM capabilities for hot-reload.

## Limitations

1. Watching for individual files changes is not available on Windows.
2. On Linux Systems, watching for new folders is not available. You may have to restart Dartmon to watch the newly created folder.
3. There might be unknown issues, as the testing phase is not yet completed.
