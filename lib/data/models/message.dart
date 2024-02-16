import 'package:intl/intl.dart';

class Message {
  final DateTime date;
  final String title;
  final String body;
  final String sender;
  final int id;

  const Message({
    required this.id,
    required this.date,
    required this.title,
    required this.body,
    required this.sender,
  });

  @override
  String toString() {
    return "id: $id,\ntitle: $title,\ndate: ${date.toString()},\nsender: $sender,\nbody: $body";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "sender": sender,
      "body": body,
      "date": date.millisecondsSinceEpoch,
    };
  }

  String getDate() {
    var formatter = DateFormat("yyyy. MM. dd.");

    return formatter.format(date);
  }
}
