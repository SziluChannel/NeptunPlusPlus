import 'package:intl/intl.dart';

class PersonalData {
  final String neptunCode;
  final String preName;
  final String firstName;
  final String lastName;
  final String fullName;
  final DateTime birthDate;
  final String birthCountry;
  final String birthCounty;
  final String birthPlace;
  final String gender;
  final String eduId;
  final String mothersName;
  final int tajNumber;
  final int taxNumber;
  final int omNumber;
  final String examId;

  PersonalData(
    this.neptunCode,
    this.preName,
    this.firstName,
    this.lastName,
    this.fullName,
    this.birthDate,
    this.birthCountry,
    this.birthCounty,
    this.birthPlace,
    this.gender,
    this.eduId,
    this.mothersName,
    this.tajNumber,
    this.taxNumber,
    this.omNumber,
    this.examId,
  );

  @override
  String toString() {
    return "\n\tname: $fullName\n\tneptunCode: $neptunCode\n\tmothers name: $mothersName";
  }

  Map<String, dynamic> toMap() {
    return {
      "neptunCode": neptunCode,
      "preName": preName,
      "firstName": firstName,
      "lastName": lastName,
      "fullName": fullName,
      "birthDate": birthDate.millisecondsSinceEpoch,
      "birthCountry": birthCountry,
      "birthCounty": birthCounty,
      "birthPlace": birthPlace,
      "gender": gender,
      "eduId": eduId,
      "mothersName": mothersName,
      "tajNumber": tajNumber,
      "taxNumber": taxNumber,
      "omNumber": omNumber,
      "examId": examId,
    };
  }

  String getBirthDate() {
    var formatter = DateFormat("yyyy. MM. dd.");
    return formatter.format(birthDate);
  }
}
