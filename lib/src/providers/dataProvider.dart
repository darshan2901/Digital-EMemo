// ignore_for_file: file_names, prefer_initializing_formals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/models/offence.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late BuildContext context;
  DataProvider({required BuildContext cntx}) {
    context = cntx;
    appLog("DataProvider initialized");
    // initApp();
    notifyListeners();
    getOffence();

    getSmtpData();
  }
  List<Offence> twoWheeler = [];
  List<Offence> fourWheeler = [];
  Map<String, Offence> twoWheelerMap = {};
  Map<String, Offence> fourWheelerMap = {};
  List<Offence> getOffenceByType({required String type}) {
    List<Offence> rt;
    if (type == "two wheeler") {
      rt = twoWheeler;
    } else {
      rt = fourWheeler;
    }
    return rt;
  }

  var smtpData;
  getOffence() {
    firestore.collection("offences").get().then((value) {
      twoWheeler.clear();
      fourWheeler.clear();
      twoWheelerMap.clear();

      fourWheelerMap.clear();
      for (QueryDocumentSnapshot element in value.docs) {
        if (element.id == "two-wheeler") {
          var data = element.data()! as Map<String, dynamic>;

          data.forEach((key, value) {
            twoWheeler.add(Offence(name: key, charge: value));
            twoWheelerMap.putIfAbsent(
                key, () => Offence(name: key, charge: value));
            notifyListeners();
          });
        } else {
          var data = element.data()! as Map<String, dynamic>;

          data.forEach((key, value) {
            fourWheeler.add(Offence(name: key, charge: value));
            fourWheelerMap.putIfAbsent(
                key, () => Offence(name: key, charge: value));
            notifyListeners();
          });
        }
      }
      notifyListeners();
    });
  }

  getSmtpData() {
    FirebaseFirestore.instance
        .collection('mail-config')
        .doc('smtp')
        .get()
        .then((value) {
      smtpData = value.data()!;
      notifyListeners();
    });
  }
}
