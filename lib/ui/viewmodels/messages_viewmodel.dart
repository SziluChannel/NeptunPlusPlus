import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/messages_database.dart';
import 'package:neptun_app/data/models/message.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:neptun_app/data/remote/message_api_service.dart';

class MessagesViewmodel extends ChangeNotifier {
  MessagesApiService messagesApiService = MessagesApiService();

  MessagesDatabaseService messagesDatabaseService = MessagesDatabaseService();

  List<Message> messages = List.empty();

  int selectedMessageId = 0;

  void getMessages() async {
    messages = await messagesDatabaseService.getMessages();

    if (ApiService.loggedIn) {
      var result = await messagesApiService
          .getMessages(DateTime.now().add(Duration(days: 10)), messageCount: 0);

      if (result.value != null) {
        //print("THE SUCCESS VALUE: ${result.value?.firstOrNull?.toString()}");
        messagesDatabaseService.insertMessages(result.value!);

        messages = await messagesDatabaseService.getMessages();
      } else {
        print("THE FAIL VALUE: ${result.error!}");
      }
    }

    notifyListeners();
  }

  void setSelected(int value) {
    if (selectedMessageId != value) {
      selectedMessageId = value;
    } else {
      selectedMessageId = 0;
    }
    notifyListeners();
  }
}
