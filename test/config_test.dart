import 'package:dartmon_cli/src/config/config.dart';
import 'package:dartmon_cli/src/options/config_option.dart';
import 'package:dartmon_cli/src/options/dart_command_option.dart';
import 'package:dartmon_cli/src/options/exec_option.dart';
import 'package:dartmon_cli/src/options/ext_option.dart';
import 'package:dartmon_cli/src/options/file_option.dart';
import 'package:dartmon_cli/src/options/help_option.dart';
import 'package:dartmon_cli/src/options/ignore_option.dart';
import 'package:dartmon_cli/src/options/no_recursive_option.dart';
import 'package:dartmon_cli/src/options/timeout_option.dart';
import 'package:dartmon_cli/src/options/version_option.dart';
import 'package:dartmon_cli/src/options/watch_option.dart';
import 'package:test/test.dart';

DartmonConfig init() {
  final config = DartmonConfig();
  config.addOption(ConfigOption());
  config.addOption(DartCommandOption());
  config.addOption(ExecOption());
  config.addOption(ExtOption());
  config.addOption(FileOption());
  config.addOption(HelpOption());
  config.addOption(IgnoreOption());
  config.addOption(NoRecursiveOption());
  config.addOption(TimeoutOption());
  config.addOption(VersionOption());
  config.addOption(WatchOption());
  return config;
}

void main() {
  test('empty init', () {
    init();
  });

  test("construct", () {
    final config = init();
    config.construct(["lib/dartmon.dart"]);
  });
  test("run", () {
    final config = init();
    config.construct(["run"]);
  });
  test("exec", () {
    final config = init();
    config.construct([
      "--exec",
      "dart run",
    ]);
  });
  test("watch", () {
    final config = init();
    config.construct([
      "--watch",
      "'lib/dartmon.dart,lib/config.dart,lib/config.dart'",
      "--watch",
      "lib/dartmon.dart,lib/config.dart,lib/config.dart",
      "run",
    ]);
    final files = config.files.map((e) => e.path);
    print("files: $files");
    expect(
        files.contains('lib/dartmon.dart') &&
            files.contains('lib/config.dart') &&
            files.contains('lib/config.dart') &&
            files.contains('lib/dartmon.dart') &&
            files.contains('lib/config.dart') &&
            files.contains('lib/config.dart'),
        true);
  });
  // test("help", () {
  //   final config = init();
  //   config.construct([
  //     "--help",
  //   ]);
  // });
  test("ext", () {
    final config = init();
    config.construct([
      "-x",
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
    final config = init();
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
    final config = init();
    config.construct([
      "--timeout",
      "10ms",
      "run",
    ]);
    expect(config.timeout != null, true);
    expect(config.timeout!.inMilliseconds, 10);
    final config2 = init();
    config2.construct([
      "--timeout",
      "50",
      "run",
    ]);
    expect(config2.timeout!.inSeconds, 50);
    final config3 = init();
    config3.construct([
      "--timeout",
      "90s",
      "run",
    ]);
    expect(config3.timeout!.inSeconds, 90);
    final config4 = init();
    config4.construct(['run']);
    expect(config4.timeout != null, true);
    expect(config4.timeout!.inMilliseconds, 1000);
  });

  test("recursive", () {
    final config = init();
    config.construct([
      "--recursive",
      "run",
    ]);
    expect(config.recursive, true);
  });
  test("ignore-files", () {
    final config = init();
    config.construct([
      "--ignore",
      "F:\\S_Data\\Flutter_Projects\\dartmon\\lib\\config.dart",
      "run",
    ]);
    print("config.ignoreFiles= ${config.ignoreFiles}");
    expect(
        config.ignoreFiles
            .contains('f:/s_data/flutter_projects/dartmon/lib/config.dart'),
        true);
  });
  test("ignore-dir", () {
    final config = init();
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
