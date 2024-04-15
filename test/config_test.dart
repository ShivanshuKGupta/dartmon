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
      "run",
    ]);
    final files = config.files.map((e) => e.path);
    print("files: $files");
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
      "run",
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
      "run",
    ]);
    expect(config.ignoreFiles.contains('hehe.dart'), false);
  });
  test("timeout", () {
    var config = DartmonConfig();
    config.construct([
      "--timeout",
      "10ms",
      "run",
    ]);
    expect(config.timeout != null, true);
    expect(config.timeout!.inMilliseconds, 10);
    config = DartmonConfig();
    config.construct([
      "--timeout",
      "50",
      "run",
    ]);
    expect(config.timeout!.inSeconds, 50);
    config = DartmonConfig();
    config.construct([
      "--timeout",
      "90s",
      "run",
    ]);
    expect(config.timeout!.inSeconds, 90);
    config = DartmonConfig();
    config.construct([]);
    expect(config.timeout != null, true);
    expect(config.timeout!.inMilliseconds, 1000);
  });

  test("recursive", () {
    final config = DartmonConfig();
    config.construct([
      "--recursive",
      "run",
    ]);
    expect(config.recursive, true);
  });
  test("ignore-files", () {
    final config = DartmonConfig();
    config.construct([
      "--ignore",
      "F:\\S_Data\\Flutter_Projects\\dartmon\\lib\\action.dart",
      "run",
    ]);
    print("config.ignoreFiles= ${config.ignoreFiles}");
    expect(
        config.ignoreFiles
            .contains('f:/s_data/flutter_projects/dartmon/lib/action.dart'),
        true);
  });
  test("ignore-dir", () {
    final config = DartmonConfig();
    config.construct([
      "--ignore",
      "F:\\S_Data\\Flutter_Projects\\dartmon\\lib",
      "run",
    ]);
    print("config.ignoreDirectories= ${config.ignoreDirectories}");
    expect(
        config.ignoreDirectories
            .contains('f:/s_data/flutter_projects/dartmon/lib'),
        true);
  });
}
