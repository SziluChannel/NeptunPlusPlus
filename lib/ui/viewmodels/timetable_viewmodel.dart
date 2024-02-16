import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neptun_app/data/local/events_database.dart';
import 'package:neptun_app/data/models/event.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:neptun_app/data/remote/timetable_api_service.dart';

class TimetableViewModel extends ChangeNotifier {
  EventsApiService eventsApiService = EventsApiService();

  EventsDatabaseService eventsDatabaseService = EventsDatabaseService();

  List<Event> events = List.empty();

  DateTime selectedDate = DateTime.now();

  String errorMessage = "";

  void updateSelectedDate(int index) {
    selectedDate = epochDaysToDate(index);
    notifyListeners();
  }

  void getEvents() async {
    events = await eventsDatabaseService.getEvents();

    if (ApiService.loggedIn) {
      var result = await eventsApiService.getEvents();

      if (result.value != null) {
        eventsDatabaseService.deleteAll();
        //print("THE SUCCESS VALUE: ${result.value.toString()}");
        eventsDatabaseService.insertEvents(result.value!
            .where((element) => !events.contains(element))
            .toList());
        events = result.value!;
        errorMessage = "";
      } else {
        print("THE FAILURE VALUE: ${result.error.toString()}");
        errorMessage = result.error!;
      }
    }
    events = [
      ...{...events}
    ];

    events.sort(
      (a, b) {
        return a.startDate.millisecondsSinceEpoch -
            b.startDate.millisecondsSinceEpoch;
      },
    );
    notifyListeners();
  }

  String getSelectedDate() {
    var formatter = DateFormat("yyyy. MM. dd");
    return formatter.format(selectedDate);
  }

  int dateToEpochDays(DateTime date) {
    return (date.millisecondsSinceEpoch / 86400000.0).floor();
  }

  DateTime epochDaysToDate(int epochDays) {
    return DateTime.fromMillisecondsSinceEpoch(epochDays * 86400000);
  }
}
