import 'package:intl/intl.dart';

class Event {
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final String location;

  final _formatter = DateFormat("HH:mm");

  Event(this.startDate, this.endDate, this.title, this.location);

  Map<String, dynamic> toMap() {
    return {
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
      "title": title,
      "location": location,
    };
  }

  @override
  String toString() {
    return "title: $title\nlocation: $location\nstartDate: $startDate\nendDate: $endDate";
  }

  String getStartDate() {
    return _formatter.format(startDate);
  }

  String getEndDate() {
    return _formatter.format(endDate);
  }
}
