import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Appuser appuserFromJson(String str) => Appuser.fromJson(json.decode(str));

String appuserToJson(Appuser data) => json.encode(data.toJson());

class Appuser {
  Appuser(
      {this.fname,
      this.lname,
      this.email,
      this.city,
      this.state,
      this.country,
      this.birthdate,
      this.usertype});

  String? fname;
  String? lname;
  String? email;
  String? city;
  String? state;
  String? country;
  Timestamp? birthdate;
  String? usertype;

  factory Appuser.fromJson(Map<String, dynamic> json) => Appuser(
        fname: json["fname"],
        lname: json["lname"],
        email: json["email"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        birthdate: json["birthdate"],
        usertype: json["usertype"],
      );

  Map<String, dynamic> toJson() => {
        "fname": fname,
        "lname": lname,
        "email": email,
        "city": city,
        "state": state,
        "country": country,
        "birthdate": birthdate,
        "usertype": usertype,
      };
}
