// To parse this JSON data, do
//
//     final offence = offenceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Offence offenceFromJson(String str) => Offence.fromJson(json.decode(str));

String offenceToJson(Offence data) => json.encode(data.toJson());

class Offence {
    Offence({
        required this.name,
        required this.charge,
    });

    String name;
    int charge;

    factory Offence.fromJson(Map<String, dynamic> json) => Offence(
        name: json["name"],
        charge: json["charge"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "charge": charge,
    };
}
