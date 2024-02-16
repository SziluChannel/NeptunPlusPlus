import 'package:neptun_app/data/models/result.dart';
import 'package:neptun_app/data/remote/api_service.dart';

class LoginApiService {
  final loginPath = "/login.aspx/CheckLoginEnable";

  final authPath = "/login.aspx/ValidateToken";

  final logoutPath = "/main.aspx/LogOutFromJS";

  Future<Result<String, String>> login(String username, String password) async {
    var body =
        "{\"user\":\"$username\",\"pwd\":\"$password\",\"UserLogin\":null,\"GUID\":null,\"captcha\":\"\"}";

    try {
      var response = await ApiService.dio.post(
        loginPath,
        data: body,
      );

      var decoded = response.data;

      var pieces = (decoded["d"] as String).split("'");

      var hds = response.headers["set-cookie"];

      var headd = hds?.map((e) {
        return e.split(";")[0];
      }).join("; ");

      if (pieces[1] == "True") {
        if (ApiService.dio.options.headers["cookie"] != "" &&
            ApiService.dio.options.headers["cookie"] != null) {
          ApiService.dio.options.headers["cookie"] =
              "${ApiService.dio.options.headers["cookie"]};  $headd";
        } else {
          ApiService.dio.options.headers["cookie"] = headd ?? "";
        }

        return Result.Ok("SUCCESS!!!");
      } else {
        return Result.Err(pieces[3]);
      }
    } catch (e) {
      return Result.Err(e.toString());
    }
  }

  Future<Result<String, String>> logout() async {
    try {
      await ApiService.dio.post(
        logoutPath,
        data: "{\"link\":\"Login.aspx?timeout=\"}",
      );

      return Result.Ok("OK");
    } catch (e) {
      return Result.Err(e.toString());
    }
  }

  Future<Result<String, String>> authenticate(
      String username, String password, String token) async {
    var body = "{\"request\":{\"Token\":\"$token\"}}";

    try {
      var response = await ApiService.dio.post(
        authPath,
        data: body,
      );

      var decoded = response.data;

      var res = decoded["d"]["Errors"];

      res = res.toString();

      if (res == "{}") {
        ApiService.loggedIn = true;
        return Result.Ok("Login success!");
      } else {
        return Result.Err(res);
      }
    } catch (e) {
      return Result.Err(e.toString());
    }
  }
}
