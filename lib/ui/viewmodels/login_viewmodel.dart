import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/credentials_database.dart';
import 'package:neptun_app/data/models/credential.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:neptun_app/data/remote/login_api_service.dart';
import 'package:otp/otp.dart';

class LoginViewmodel extends ChangeNotifier {
  var loggedIn = false;
  var authenticated = false;
  var username = "";
  var password = "";
  var errorMessage = "";
  bool autoLogin = false;
  LoginApiService loginApiService = LoginApiService();
  CredentialsDatabaseService credentialsDatabaseService =
      CredentialsDatabaseService();

  // returns true if at least login is successful with saved creds
  Future<bool> getCredentialsAndAutoLogin() async {
    var credentials = await credentialsDatabaseService.getCredentials();

    if (credentials.isNotEmpty) {
      username = credentials.first.username;
      password = credentials.first.password;
      var hash = credentials.first.hash;

      bool result = await login(
        username,
        password,
        false,
      );
      autoLogin = result;

      if (result && hash.isNotEmpty) {
        bool authResult = await authenticate(
          generateKey(hash),
        );
      }

      notifyListeners();
      return result;
    }
    return false;
  }

  String generateKey(String hash) {
    return OTP.generateTOTPCodeString(
      hash,
      DateTime.now().millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      interval: 30,
      isGoogle: true,
    );
  }

  Future<bool> login(String uname, String pwd, bool saveCredentials) async {
    var finalname = uname == "" ? username : uname;
    var finalpass = pwd == "" ? password : pwd;
    var response = await loginApiService.login(finalname, finalpass);

    if (response.value != null) {
      errorMessage = "";
      // azért itt setelem az usernamet meg passwordot
      // mert ha elcseszi akkor ne mentsük már ide be
      username = finalname;
      password = finalpass;
      loggedIn = true;

      var creds = await credentialsDatabaseService.getCredentials();

      if (saveCredentials) {
        if (creds.isNotEmpty) {
          credentialsDatabaseService.updateCredential(
            Credential(
              username,
              password,
              creds.first.hash,
            ),
          );
        } else {
          credentialsDatabaseService.insertCredential(
            Credential(username, password, ""),
          );
        }
      }
      notifyListeners();
      return true;
    } else {
      print("FAILED TO LOG IN: ${response.error}");
      errorMessage = response.error!;
    }
    notifyListeners();
    return false;
  }

  void logout() async {
    var result = await loginApiService.logout();
    if (result.value != null) {
      //print("LOGGED OUT!");
    } else {
      print("LOGOUT ERROR: ${result.error!}");
    }
    authenticated = false;
    loggedIn = false;
    ApiService.loggedIn = false;
    notifyListeners();
  }

  Future<bool> authenticate(String token) async {
    var response =
        await loginApiService.authenticate(username, password, token);

    if (response.value != null) {
      authenticated = true;
      errorMessage = "";
      ApiService.loggedIn = true;
      notifyListeners();
      return true;
    } else {
      authenticated = false;
      loggedIn = false;
      print("FAILED TO LOG IN: ${response.error}");
      errorMessage = response.error!;
      notifyListeners();
      return false;
    }
  }
}
