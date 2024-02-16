import 'dart:convert';

class Credential {
  final String username;
  final String password;
  final String hash;

  Credential(
    this.username,
    this.password,
    this.hash,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": 0,
      "username": username,
      "password": password,
      "hash": hash,
    };
  }

  @override
  String toString() {
    return """
Credential {
  username: $username,
  password: ${base64.encode(utf8.encode(password))},
  hash: $hash
}      """;
  }
}
