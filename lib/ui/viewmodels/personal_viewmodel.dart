import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/personal_database.dart';
import 'package:neptun_app/data/models/personal_data.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:neptun_app/data/remote/personal_api_service.dart';

class PersonalViewmodel extends ChangeNotifier {
  PersonalApiService personalApiService = PersonalApiService();

  PersonalDatabaseService personalDatabaseService = PersonalDatabaseService();

  PersonalData? data;

  void getPersonalData() async {
    var list = await personalDatabaseService.getPersonalData();

    if (list.isNotEmpty) {
      data = list.first;
    }

    if (ApiService.loggedIn) {
      var result = await personalApiService.getPersonalData();

      if (result.value != null) {
        print("THE PERSONAL DATA: ${result.value}");
        data = result.value;
        personalDatabaseService.insertPersonalData(result.value!);
      } else {
        print("THE FAIL ERROR: ${result.error}");
      }
    }

    notifyListeners();
  }
}
