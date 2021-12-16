// To parse this JSON data, do
//
//     final chalan = chalanFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Chalan chalanFromJson(String str) => Chalan.fromJson(json.decode(str));

String chalanToJson(Chalan data) => json.encode(data.toJson());

class Chalan {
  Chalan({
    this.transactionDate,
    this.fineBy,
    this.offences,
    this.fineTo,
    this.vehicleNumber,
    this.location,
    this.fineAmount,
    this.issueDate,
    this.paymentDone,
  });

  Timestamp? transactionDate;
  String? fineBy;
  List<dynamic>? offences;
  String? fineTo;
  String? vehicleNumber;
  String? location;
  int? fineAmount;
  Timestamp? issueDate;
  bool? paymentDone;

  factory Chalan.fromJson(Map<String, dynamic> json) => Chalan(
        transactionDate: json["transactionDate"],
        fineBy: json["fineBy"],
        offences: List<dynamic>.from(json["offences"].map((x) => x)),
        fineTo: json["fineTo"],
        vehicleNumber: json["vehicleNumber"],
        location: json["location"],
        fineAmount: json["charges"],
        issueDate: json["issueDate"],
        paymentDone: json["paymentDone"],
      );

  Map<String, dynamic> toJson() => {
        "transactionDate": transactionDate,
        "fineBy": fineBy,
        "offences": List<dynamic>.from(offences!.map((x) => x)),
        "fineTo": fineTo,
        "vehicleNumber": vehicleNumber,
        "location": location,
        "charges": fineAmount,
        "issueDate": issueDate,
        "paymentDone": paymentDone,
      };
}
