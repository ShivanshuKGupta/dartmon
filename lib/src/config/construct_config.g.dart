part of 'config.dart';

extension on DartmonConfig {
  /// Constructs the config using the arguments passed to the command
  void constructUsingArguments(List<String> arguments) {
    _logger.write("Constructing config from arguments: $arguments");
    this.arguments = arguments;
    if (arguments.isEmpty) {
      _logger.write("Arguments are empty! Showing help and exiting...");
      options.firstWhere((element) => element is HelpOption).handler(null);
      exit(0);
    }

    /// Parsing the arguments,
    /// We first try to parse the arguments using options which have a defined
    /// invocation, if none of the options can handle the argument, we try to
    /// handle it using the other options, also known as the Unknown Option in
    /// this context.
    for (nextArgumentIndex = 0;
        nextArgumentIndex < arguments.length;
        ++nextArgumentIndex) {
      String option = arguments[nextArgumentIndex];
      String? value;

      /// An option is by default followed by a value
      /// We detect the value by checking if the next argument does not starts
      /// with a '-'
      ///
      /// Options may choose not to parse a value, in that case, the option
      /// should decrement the value of nextArgumentIndex, such that the next
      /// argument can be parsed normally
      ///
      /// The following fixes are applied on the value before sending it to the
      /// option handler:
      /// 1. If the value is enclosed in quotes, we remove the quotes
      /// 2. If the value is enclosed in single quotes, we remove the quotes
      /// 3. We also remove any extra spaces in the value
      if (arguments.length > nextArgumentIndex + 1 &&
          !arguments[nextArgumentIndex + 1].startsWith('-')) {
        nextArgumentIndex++;
        value = arguments[nextArgumentIndex];
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        } else if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        }
        value = value.trim();
        value = value.replaceAll(RegExp(r'\s{2,}'), ' ');
      }
      _logger.write("Parsing option: $option with value: $value");

      /// Here, we try to handle the argument using the options with known
      /// invocations
      bool handled = false;
      for (int i = 0; i < options.length; i++) {
        if (options[i].invocations.contains(option)) {
          _logger.write(
              "Handling using option: ${options[i].name} with value: $value");
          options[i].handler(value);
          handled = true;
          break;
        }
      }

      /// if the argument was not handled by the known options, we try to handle
      /// it using the unknown options
      if (!handled) {
        for (int i = 0; i < unknownOptions.length; i++) {
          _logger.write(
              "Handling using unknown option: ${unknownOptions[i].name} with value: $value");
          handled = handled || unknownOptions[i].handler(value);
          if (handled) {
            _logger.write(
                "Handled using unknown option: ${unknownOptions[i].name}");
            break;
          } else {
            _logger.write(
                "Handling failed using unknown option: ${unknownOptions[i].name}");
          }
        }
      }

      /// If the argument was not handled by any of the options, we throw an
      /// error
      if (!handled) {
        _logger.write(
            "No option was able to handle the argument: $option.\nThrowing an error");
        throw "Unknown option: $option";
      }
    }

    /// Default values for the config
    if (timeout == null) {
      _logger.write("Timeout is set to default: 1 second");
      timeout = Duration(seconds: 1);
    }

    /// Checks before running the command
    if (cmd == null) {
      _logger.write("No command was set to run! Below is the config instance:");
      _logger.write(toJson());
      throw "Nothing to run!";
    }

    /// Making sure the ignoreDirectories are absolute paths
    /// because the watcher will compare the absolute paths
    /// with the paths of the files and directories being separated by a /
    /// not a \\
    ignoreDirectories = ignoreDirectories.map((e) {
      return Directory(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();

    /// Making sure the ignoreFiles are absolute paths
    /// because the watcher will compare the absolute paths
    /// with the paths of the files and directories being separated by a /
    /// not a \\
    ignoreFiles = ignoreFiles.map((e) {
      return File(e).absolute.path.toLowerCase().replaceAll('\\', '/');
    }).toList();

    _logger.write("Config constructed successfully:\n${toJson()}");
  }
}
