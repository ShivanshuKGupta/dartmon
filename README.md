# Dartmon

A simple file watcher for Dart Projects. Can also be used to watch any other file types, or applications.

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
  More commands will be here soon...

Run 'dartmon --help <command>' for more information about a command.
```

## Limitations

1. Watching for individual files changes is not available on Windows.
2. On Linux Systems, watching for new folders is not available. You may have to restart Dartmon to watch the newly created folder.
3. There might be unknown issues, as the testing phase is not yet completed.
