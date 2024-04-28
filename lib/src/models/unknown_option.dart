import 'package:dartmon/src/models/option.dart';

/// Just a wrapper over the option class
///
/// This is used for commands that do not have a defined invocation
///
/// For ex,
/// dartmon main.dart
/// Here, `main.dart` is an invocation that is not defined in any of the options
/// So, dartmon will try to send this invocation to the UnknownOptions one-by-one
/// in the order they are added to the config, until one of them handles it
abstract class UnknownOption extends Option<bool> {
  @override
  List<String> get invocations => [];
}
