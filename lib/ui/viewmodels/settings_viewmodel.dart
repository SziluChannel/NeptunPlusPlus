import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neptun_app/data/local/credentials_database.dart';
import 'package:neptun_app/data/models/credential.dart';

class SettingsViewmodel extends ChangeNotifier {
  CredentialsDatabaseService credentialsDatabaseService =
      CredentialsDatabaseService();

  bool keySaved = false;

  Future<bool> isKeySaved() async {
    keySaved = false;
    var creds = await credentialsDatabaseService.getCredentials();
    if (creds.isNotEmpty) {
      keySaved = creds.first.hash.isNotEmpty;
    }
    notifyListeners();
    return keySaved;
  }

  void saveAuthSecretKey(String secretKey) async {
    /*
    var code = OTP.generateTOTPCodeString(
      "OWAAFSAW2AMCOIMIDIGBQ3MLFTIPECUXPJSSPKI64UPKCRLZ7KDMM5OI",
      DateTime.now().millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      interval: 30,
      isGoogle: true,
    );

    print("THE CODE TOTP: $code");
    */

    var creds = await credentialsDatabaseService.getCredentials();

    if (creds.isNotEmpty) {
      var cred = creds.first;
      credentialsDatabaseService.updateCredential(
        Credential(
          cred.username,
          cred.password,
          secretKey,
        ),
      );
    } else {
      credentialsDatabaseService.insertCredential(
        Credential(
          "",
          "",
          secretKey,
        ),
      );
    }
  }

  //THEME SECTION
  ThemeMode themeMode = ThemeMode.system;
  bool darkTheme =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  void setTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    darkTheme = isDark;
    notifyListeners();
  }
}
