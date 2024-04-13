extension DurationExtension on Duration {
  /// This extension method is used to convert a string to a Duration object.
  /// This supports the following formats:
  /// - '1ms', '1msec', '1msecs', '1millisecond', '1milliseconds' for milliseconds
  /// - '1s', '1sec', '1secs', '1second', '1seconds' for seconds
  /// by default, the value is in seconds (if no unit is provided).
  /// If the string is not in the correct format, it will return null.
  /// This method also supports floating point numbers.
  static Duration? tryParse(String value) {
    value = value.trim();
    String unit = value.replaceAll(RegExp(r'[0-9]'), '');
    double? number;
    int seconds = 0;
    int milliseconds = 0;

    /// Try to parse the number
    number = double.tryParse(value.replaceAll(unit, ''));
    if (number == null) return null;

    /// Switch the unit and set the milliseconds and seconds accordingly
    switch (unit) {
      case 'ms':
      case 'msec':
      case 'msecs':
      case 'millisecond':
      case 'milliseconds':
        milliseconds = number.toInt();
        break;
      case '':
      case 's':
      case 'sec':
      case 'secs':
      case 'second':
      case 'seconds':
        seconds = number.toInt();
        // milliseconds = (number * 1000).toInt();
        milliseconds = ((number - seconds) * 1000).toInt();
        break;
      default:
        // Unknown unit
        return null;
    }

    return Duration(
      milliseconds: milliseconds,
      seconds: seconds,
    );
  }

  String toUnitString() {
    // return a string representation of the duration with unit
    if (inMilliseconds > 0) {
      return '${inMilliseconds}ms';
    } else {
      return '${inSeconds}s';
    }
  }
}
