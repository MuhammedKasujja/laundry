// To parse this JSON data, do
//
//     final mapZone = mapZoneFromJson(jsonString);

import 'dart:convert';

MapZone mapZoneFromJson(String str) => MapZone.fromJson(json.decode(str));

String mapZoneToJson(MapZone data) => json.encode(data.toJson());

class MapZone {
  List<Zone> zone;

  MapZone({
    required this.zone,
  });

  factory MapZone.fromJson(Map<String, dynamic> json) => MapZone(
        zone: List<Zone>.from(json["Zone"].map((x) => Zone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Zone": List<dynamic>.from(zone.map((x) => x.toJson())),
      };
}

class Zone {
  double lat;
  double lng;

  Zone({
    required this.lat,
    required this.lng,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
