import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neptun_app/data/local/credentials_database.dart';
import 'package:neptun_app/data/models/credential.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewmodel extends ChangeNotifier {
  CredentialsDatabaseService credentialsDatabaseService =
      CredentialsDatabaseService();

  bool keySaved = false;
  bool passwordSaved = false;
  String secretKey = "";

  Future<bool> isKeySaved() async {
    keySaved = false;
    var creds = await credentialsDatabaseService.getCredentials();
    if (creds.isNotEmpty) {
      keySaved = creds.first.hash.isNotEmpty;
    }
    notifyListeners();
    return keySaved;
  }

  Future<bool> isPasswordSaved() async {
    passwordSaved = false;
    var creds = await credentialsDatabaseService.getCredentials();
    if (creds.isNotEmpty) {
      passwordSaved = creds.first.password.isNotEmpty;
    }
    notifyListeners();
    return passwordSaved;
  }

  Future<String> verifyPasswordAndGetKey(String password) async {
    var creds = await credentialsDatabaseService.getCredentials();
    if (creds.isNotEmpty) {
      return creds.first.password == password ? creds.first.hash : "";
    }
    return "";
  }

  Future<bool> verifyPassword(String password) async {
    var creds = await credentialsDatabaseService.getCredentials();

    if (creds.isNotEmpty) {
      if (creds.first.password == password) {
        secretKey = creds.first.hash;
        return true;
      }
    }
    return false;
  }

  void clearKey() async {
    var creds = await credentialsDatabaseService.getCredentials();
    var newKey = Credential(creds.first.username, creds.first.password, "");
    credentialsDatabaseService.updateCredential(newKey);
    keySaved = false;
    notifyListeners();
  }

  void clearCredentials() async {
    credentialsDatabaseService.deleteCredentials();
    keySaved = false;
    notifyListeners();
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
    keySaved = true;
    notifyListeners();
  }

  //THEME SECTION
  ThemeMode themeMode = ThemeMode.system;
  bool darkTheme =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  void setTheme(bool isDark) async {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    darkTheme = isDark;

    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkTheme", isDark);
    notifyListeners();
  }

  void getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    var dark = prefs.getBool("darkTheme");
    if (dark != null) {
      setTheme(dark);
    }
  }
}
