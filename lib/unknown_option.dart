import 'package:dartmon/option.dart';

abstract class UnknownOption extends Option<bool> {
  @override
  List<String> get invocations => [];
}
