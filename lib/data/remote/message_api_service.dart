import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:neptun_app/data/models/message.dart';
import 'package:neptun_app/data/models/result.dart';
import 'package:neptun_app/data/remote/api_service.dart';

class MessagesApiService {
  final messagesPath = "/main.aspx?ismenuclick=true&ctrl=inbox";

  final messagePath = "/main.aspx";

  Future<Result<List<Message>, String>> getMessages(DateTime lastMessageDate,
      {int messageCount = -1}) async {
    try {
      var response = await ApiService.dio.get(
        messagesPath,
      );

      var messages = await extractMessages(response.data);

      return Result.Ok(messages);
    } catch (e) {
      return Result.Err(e.toString());
    }
  }

  Future<List<Message>> extractMessages(String html) async {
    try {
      var document = parse(html);

      var tbodyy =
          document.body?.querySelector("#c_messages_gridMessages_bodytable");

      var tbody = tbodyy
          ?.getElementsByTagName("tbody")[0]
          .getElementsByTagName("tr")
          .toList();

      return Future.wait(tbody?.sublist(0, 10).map((e) {
            var span = e.getElementsByTagName("span").firstOrNull;

            var id =
                int.tryParse(span?.attributes["onclick"]?.split("'")[1] ?? "");

            var tdk = e.getElementsByTagName("td");

            return Message(
                id: id ?? -1,
                date: getDateFromPattern(tdk.last.text),
                title: span?.text.trim() ?? "",
                body: "",
                sender: tdk.getRange(4, 5).firstOrNull?.text.trim() ?? "");
          }).map((e) async {
            return Message(
              id: e.id,
              title: e.title,
              date: e.date,
              body: await getMessage(e.id),
              sender: e.sender,
            );
          }).toList() ??
          List.empty());
    } catch (e) {
      return List.empty();
    }
  }

  Future<String> getMessage(int id) async {
    var body = {
      "ToolkitScriptManager1":
          "ToolkitScriptManager1|upFunction\$c_messages\$upMain\$upGrid\$gridMessages",
      "ToolkitScriptManager1_HiddenField": "",
      "__EVENTTARGET": "upFunction\$c_messages\$upMain\$upGrid\$gridMessages",
      "__EVENTARGUMENT":
          "commandname=Subject;commandsource=select;id=$id;level=1",
      "__ASYNCPOST": "true",
    };

    try {
      var result = await ApiService.dio.post(
        messagesPath,
        data: FormData.fromMap(body),
      );

      var html = parse(result.data).body;

      var htm = html
          ?.querySelector(
              "#upFunction_c_messages_upModal_upmodalextenderReadMessage_ctl02_Readmessage1_UpdatePanel1_readmessage_wrapper")
          ?.getElementsByClassName("readmessage_editor")[0];

      return htm?.innerHtml.trim() ?? "";
    } catch (e) {
      return e.toString();
    }
  }

  DateTime getDateFromPattern(String pattern) {
    try {
      var dt = pattern.split(".").map((e) => e.trim()).toList();

      var tm = dt.last.split(":").map((e) => int.tryParse(e.trim())).toList();

      return DateTime(
        int.parse(dt[0]),
        int.parse(dt[1]),
        int.parse(dt[2]),
        tm[0]!,
        tm[1]!,
        tm[2]!,
      );
    } catch (e) {
      return DateTime.now();
    }
  }
}
