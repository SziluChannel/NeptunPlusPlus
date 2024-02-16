import 'package:dio/dio.dart';

class ApiService {
  static ApiService? _instance;

  ApiService._();

  static bool loggedIn = false;

  factory ApiService() {
    _instance ??= ApiService._();
    return _instance!;
  }

  static Dio dio = Dio(
    BaseOptions(
      headers: {
        "user-agent":
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "authority": "www-h.neptun.unideb.hu",
        "origin": "https://www-h.neptun.unideb.hu",
        "accept": "application/json, text/javascript, */*; q=0.01",
        "accept-content-type": "application/json; charset=UTF-8",
        "accept-language": "en-US,en;q=0.8",
        "content-type": "application/json; charset=UTF-8",
        "sec-ch-ua":
            "\"Not A(Brand\";v=\"99\", \"Brave\";v=\"121\", \"Chromium\";v=\"121\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "Linux",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "sec-gpc": "1",
        "scheme": "https",
        "x-requested-with": "XMLHttpRequest",
        "Accept-Encoding": "gzip, deflate, br",
        "method": "POST",
      },
      baseUrl: "https://www-h.neptun.unideb.hu/hallgato",
    ),
  );
}
