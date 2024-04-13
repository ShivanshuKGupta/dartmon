import 'package:dartmon/event.dart';

class DartmonAction {
  final DartmonEvent event;
  final String cmd;

  DartmonAction({required this.event, required this.cmd});

  @override
  String toString() {
    return 'Action{event: $event, cmd: $cmd}';
  }

  Map<String, String> toJson() {
    return {
      'event': event.toString().split('.').last,
      'cmd': cmd,
    };
  }

  factory DartmonAction.fromJson(Map<String, dynamic> json) {
    return DartmonAction(
      event: DartmonEvent.values.firstWhere(
        (e) => e.toString().split('.').last == json['event'],
      ),
      cmd: json['cmd'],
    );
  }
}
