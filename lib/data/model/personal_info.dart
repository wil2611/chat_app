
import 'package:firebase_database/firebase_database.dart';

class PersonalInfo {
  String? key;
  String email;
  String firstName;
  String lastName;
  String birthday;


  PersonalInfo(this.key, this.email, this.firstName, this.lastName, this.birthday);

  PersonalInfo.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key ?? "0",
        email = json['email'] ?? "email",
        firstName = json['firstName'] ?? "firstName",
        lastName = json['lastName'] ?? "lastName",
        birthday = json['birthday'] ?? "birthday";

  toJson() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "birthday": birthday,
    };
  }
}
