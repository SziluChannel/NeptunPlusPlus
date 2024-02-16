import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:neptun_app/data/models/result.dart';
import 'package:neptun_app/data/remote/api_service.dart';

class TrainingApiService {
  final trainingIdPath = "/main.aspx";

  Future<Result<List<(String, String)>, String>> getTrainingIds() async {
    try {
      var response = await ApiService.dio.post(
        trainingIdPath,
        data: FormData.fromMap(
          {
            "ToolkitScriptManager1":
                "ToolkitScriptManager1|upFunction\$c_messages\$upMain\$upGrid\$gridMessages",
            "ToolkitScriptManager1_HiddenField": "",
            "__EVENTTARGET": "SDAUpdatePanel1\$lbtnChangeTraining",
            "__EVENTARGUMENT": "",
            "__ASYNCPOST": "true",
          },
        ),
      );

      var tmp = parse(response.data)
          .body
          ?.querySelector("select")
          ?.querySelectorAll("option")
          .map((e) {
        return (e.text, e.attributes["value"] ?? "");
      }).toList();

      if (tmp?.isNotEmpty ?? false) {
        return Result.Ok(tmp!);
      }
      return Result.Err("THE VALUE IS EMPTY!");
    } catch (e) {
      return Result.Err(e.toString());
    }
  }
}
