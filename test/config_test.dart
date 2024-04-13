import 'package:dartmon/config.dart';
import 'package:test/test.dart';

void main() {
  test('empty init', () {
    DartmonConfig();
  });

  test("construct", () {
    final config = DartmonConfig();
    config.construct(["lib/dartmon.dart"]);
    print(config);
  });
  test("run", () {
    final config = DartmonConfig();
    config.construct(["run"]);
    print(config);
  });
  test("exec", () {
    final config = DartmonConfig();
    config.construct([
      "--exec",
      "dart run",
    ]);
    print(config);
  });
  test("watch", () {
    final config = DartmonConfig();
    config.construct([
      "--watch",
      "'lib/dartmon.dart,lib/config.dart,lib/action.dart'",
      "--watch",
      "lib/dartmon.dart,lib/config.dart,lib/action.dart",
    ]);
    final files = config.files.map((e) => e.path);
    expect(
        files.contains('lib/dartmon.dart') &&
            files.contains('lib/config.dart') &&
            files.contains('lib/action.dart') &&
            files.contains('lib/dartmon.dart') &&
            files.contains('lib/config.dart') &&
            files.contains('lib/action.dart'),
        true);
  });
  test("help", () {
    final config = DartmonConfig();
    config.construct([
      "--help",
    ]);
    print(config);
  });
  test("ext", () {
    final config = DartmonConfig();
    config.construct([
      "-e",
      ".dart,.yaml,py",
    ]);
    expect(
        config.ext.contains('.dart') &&
            config.ext.contains('.yaml') &&
            config.ext.contains('.py'),
        true);
  });
  test("ignore", () {
    final config = DartmonConfig();
    config.construct([
      "--ignore",
      "test/config_test.dart,lib/config.dart",
      "--ignore",
      "hehe.dart",
    ]);
    expect(config.ignoreFiles.contains('hehe.dart'), false);
  });
  test("timeout", () {
    var config = DartmonConfig();
    config.construct([
      "--timeout",
      "10ms",
    ]);
    expect(config.timeout != null, true);
    expect(config.timeout!.inMilliseconds, 10);
    config = DartmonConfig();
    config.construct([
      "--timeout",
      "50",
    ]);
    expect(config.timeout!.inSeconds, 50);
    config = DartmonConfig();
    config.construct([
      "--timeout",
      "90s",
    ]);
    expect(config.timeout!.inSeconds, 90);
    config = DartmonConfig();
    config.construct([]);
    expect(config.timeout != null, true);
    expect(config.timeout!.inMilliseconds, 20);
  });

  test("recursive", () {
    final config = DartmonConfig();
    config.construct([
      "--recursive",
    ]);
    expect(config.recursive, true);
  });
}
