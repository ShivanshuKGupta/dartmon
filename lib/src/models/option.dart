import 'package:dartmon/src/config/config.dart';

/// All global options and command are known as Options in Dartmon
///
/// For creating a new option, we need to extend this class and implement the
/// abstract methods. After that, we can add the option to the list of options
/// by calling [config.addOption(OptionName())] where config is an instance of
/// [DartmonConfig]
abstract class Option<T> {
  /// The name of the option
  String get name;

  /// The command that triggers the option
  ///
  /// For ex, for help option, the invocations are [`--help`, `-h`]
  List<String> get invocations;

  /// A short msg to be shown when user asks for help
  String get help;

  /// The handler function that is called when the option is invoked
  /// using the invocations
  T handler(String? value);

  /// The config instance that is used to get the config values
  late DartmonConfig config;

  /// The usage of the option
  ///
  /// This getter is called when the user calls
  /// dartmon --help <command>
  String get usage;
}
