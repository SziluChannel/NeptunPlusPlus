import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:neptun_app/data/models/event.dart';
import 'package:neptun_app/data/models/result.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:intl/intl.dart';
import 'package:neptun_app/data/remote/training_api_service.dart';

class EventsApiService {
  TrainingApiService trainingApiService = TrainingApiService();

  Future<Result<List<Event>, String>> getEvents() async {
    var mozst = DateTime.now().add(Duration(days: -10));

    var metdik = DateTime(mozst.year, mozst.month, mozst.day + 70);

    var formatter = DateFormat("yyyy.MM.dd");

    var mozsdt = formatter.format(mozst);

    var mettik = formatter.format(metdik);

    var trainings = await trainingApiService.getTrainingIds();

    if (trainings.error != null) {
      return Result.Err(trainings.error!);
    }

    var timetablePath =
        "/CommonControls/SaveFileDialog.aspx?id=1_0_0_0_0_0_0&Func=exportcalendar&from=$mozsdt&to=$mettik&trainingid=${trainings.value?[0].$2}";

    try {
      var response = await ApiService.dio.get(
        timetablePath,
      );

      var cali = ICalendar.fromString(response.data);

      return Result.Ok(jsonToEvents(cali.toJson()));
    } catch (e) {
      return Result.Err(e.toString());
    }
  }

  List<Event> jsonToEvents(Map<String, dynamic> json) {
    var tmp = json["data"] as List<dynamic>;
    tmp = tmp.where((event) => event["type"] == "VEVENT").map((event) {
      return Event(
        DateTime.parse(event["dtstart"]["dt"]),
        DateTime.parse(event["dtend"]["dt"]),
        event["summary"],
        event["location"],
      );
    }).toList();

    return tmp as List<Event>;
  }
}
