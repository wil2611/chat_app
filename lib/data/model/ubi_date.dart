import 'package:firebase_database/firebase_database.dart';

class Ubi {
  String? key;
  String latitude;
  String longitude;
  String online;

  Ubi(this.key, this.latitude, this.longitude, this.online);

  Ubi.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key ?? "0",
        longitude = json['longitude'] ?? "longitude",
        latitude = json['latitude'] ?? "latitude",
        online = json['online'] ?? "online";

  toJson() {
    return {
      "longitude": longitude,
      "latitude": latitude,
      "online": online,
    };
  }
}
