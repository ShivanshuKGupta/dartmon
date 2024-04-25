import 'dart:io';

import 'package:dartmon/config/config.dart';
import 'package:dartmon/services/logger.dart';

class DartProcessService {
  final DartmonConfig config;
  Process? process;
  static final Logger _logger = Logger('ProcessService');

  DartProcessService(this.config);
}
