import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/credentials_database.dart';
import 'package:neptun_app/data/models/credential.dart';
import 'package:neptun_app/data/remote/api_service.dart';
import 'package:neptun_app/data/remote/login_api_service.dart';

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

  Future<bool> getCredentialsAndAutoLogin() async {
    var credentials = await credentialsDatabaseService.getCredentials();

    if (credentials.isNotEmpty) {
      username = credentials.first.username;
      password = credentials.first.password;
      bool result = await login(
        username,
        password,
        false,
      );
      autoLogin = result;

      notifyListeners();
      return result;
    }
    return false;
  }

  Future<bool> login(String uname, String pwd, bool saveCredentials) async {
    var finalname = uname == "" ? username : uname;
    var finalpass = pwd == "" ? password : pwd;
    var response = await loginApiService.login(finalname, finalpass);

    if (response.value != null) {
      errorMessage = "";
      username = finalname;
      password = finalpass;
      loggedIn = true;
      //print("HELLLOOOO $username");
      if (saveCredentials) {
        credentialsDatabaseService.insertCredential(
          Credential(username, password, ""),
        );
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

  void authenticate(String token) async {
    var response =
        await loginApiService.authenticate(username, password, token);

    if (response.value != null) {
      authenticated = true;
      //print("HELLLOOOO $username");
      errorMessage = "";
      ApiService.loggedIn = true;
    } else {
      authenticated = false;
      loggedIn = false;
      print("FAILED TO LOG IN: ${response.error}");
      errorMessage = response.error!;
    }
    notifyListeners();
  }
}
