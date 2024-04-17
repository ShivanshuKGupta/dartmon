import 'package:dartmon/models/option.dart';

class ExtOption extends Option {
  @override
  handler(String? value) {
    if (value == null) throw "Argument for --ext is missing";
    config.ext
        .addAll(value.split(',').map((e) => e.startsWith('.') ? e : '.$e'));
  }

  @override
  String get help => "Watch files with the given extensions only.";

  @override
  List<String> get invocations => [
        '--ext',
        '-x',
      ];

  @override
  String get name => "ext";

  @override
  String get usage =>
      "Usage: dartmon --ext <ext1>,<ext2>,<ext3>\n\nWatch files with the given extensions only.\n\nExample: dartmon --ext dart,html,css\n\nNote: You can watch files with multiple extensions by separating them with a comma.\nLike this: dartmon --ext dart,html,css\n\nNote: By default, dartmon watches all files.";
}
