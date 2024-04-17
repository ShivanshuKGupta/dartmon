import 'package:dartmon/config.dart';

abstract class Option<T> {
  String get name;

  List<String> get invocations;

  String get help;

  T handler(String? value);

  late DartmonConfig config;

  String get usage;
}
