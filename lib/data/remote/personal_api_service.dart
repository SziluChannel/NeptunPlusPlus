import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:neptun_app/data/models/personal_data.dart';
import 'package:neptun_app/data/models/result.dart';
import 'package:neptun_app/data/remote/api_service.dart';

class PersonalApiService {
  final personalPath = "/main.aspx?ismenuclick=true&ctrl=0101";

  Future<Result<PersonalData, String>> getPersonalData() async {
    try {
      var response = await ApiService.dio.get(
        personalPath,
        queryParameters: {
          "ismenuclick": true,
          "ctrl": "0101",
        },
      );

      return Result.Ok(extractDataFromHtml(response.data));
    } catch (e) {
      return Result.Err(e.toString());
    }
  }

  PersonalData extractDataFromHtml(String html) {
    var data = parse(html).body;

    var mainDiv = data?.querySelector(
        "#upFunction_c_mydata_upParent_tab_SDAWebTabItem1_upTorzsadatok");

    var leftData = mainDiv
        ?.querySelector("#dtbTorzsadatok_tableBodyLeft")
        ?.getElementsByTagName("tr");

    var rightData = mainDiv
        ?.querySelector("#dtbTorzsadatok_tableBodyRight")
        ?.getElementsByTagName("tr");

    var birthData = dataFromTr(leftData?[8]).split(".").map(
      (e) {
        return int.parse(e.trim() == "" ? "0" : e.trim());
      },
    ).toList();

    return PersonalData(
      dataFromTr(leftData?[0]),
      dataFromTr(leftData?[1]),
      dataFromTr(leftData?[3]),
      dataFromTr(leftData?[2]),
      dataFromTr(leftData?[4]),
      DateTime(birthData[0], birthData[1], birthData[2]),
      dataFromTr(leftData?[9]),
      dataFromTr(leftData?[10]),
      dataFromTr(leftData?[11]),
      dataFromTr(rightData?[0]),
      dataFromTr(rightData?[1]),
      dataFromTr(rightData?[2]),
      int.parse(dataFromTr(rightData?[6])),
      int.parse(dataFromTr(rightData?[7])),
      int.parse(dataFromTr(rightData?[8])),
      dataFromTr(rightData?[9]),
    );
  }

  String dataFromTr(Element? tr) {
    return tr
            ?.getElementsByTagName("td")[0]
            .getElementsByTagName("span")[1]
            .text ??
        "";
  }
}
