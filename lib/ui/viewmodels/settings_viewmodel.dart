import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/credentials_database.dart';

class SettingsViewmodel extends ChangeNotifier {
  CredentialsDatabaseService credentialsDatabaseService =
      CredentialsDatabaseService();

  void saveAuthSecretKey(String secretKey) async {
    print("SAVE AUTH SECRET!!!!");
  }

  void setTheme(bool darkTheme) async {}
}
