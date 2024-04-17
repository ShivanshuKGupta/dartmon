import 'package:dartmon/models/option.dart';

abstract class UnknownOption extends Option<bool> {
  @override
  List<String> get invocations => [];
}
