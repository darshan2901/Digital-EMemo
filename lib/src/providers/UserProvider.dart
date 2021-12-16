// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/dashboard/dashBoard.dart';
import 'package:e_chalan/src/models/appuser.dart';
import 'package:e_chalan/src/onboarding/onboarding.dart';
import 'package:e_chalan/src/utility/functions.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:e_chalan/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Appuser? user;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot? mydata;
  BuildContext? context;

  UserProvider({BuildContext? cntx}) {
    context = cntx;
  }

  Future<bool> fetchLogedUser({required BuildContext cntx}) async {
    appLog("fetching userdata from server");
    context = cntx;
    notifyListeners();
    bool code = false;
    if (FirebaseAuth.instance.currentUser != null) {
      appLog("user already login");
      await FirebaseFirestore.instance
          .collection("officer")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        var data = snapshot.data()!;
        mydata = snapshot;
        user = Appuser.fromJson(data as Map<String, dynamic>);
        code = true;
        nonReplaceblePushNamed(context: cntx, routeName: Dashboard.routeName);
        appLog("Going to dashboard");
        notifyListeners();
      });
      notifyListeners();
    } else {
      code = false;
      nonReplaceblePushNamed(context: cntx, routeName: Onboarding.routeName);
      appLog("user is Not login");
      appLog("Going to onboarding");
    }
    return code;
  }

  Future<bool> refreshAuthdata() async {
    var r = false;
    await FirebaseAuth.instance.currentUser!.reload().then((value) {
      appLog("email verfified:");
      appLog(FirebaseAuth.instance.currentUser!.emailVerified);
      notifyListeners();
      r = true;
    });
    return r;
  }

  sendVerificationemail() {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
        CustomSnackBar(
                actionTile: "close",
                haserror: false,
                scaffoldKey: scaffoldKey,
                isfloating: false,
                onPressed: () {},
                title: "Email Verification mail sent successfully!")
            .show();
      });
    } catch (e) {
      CustomSnackBar(
              actionTile: "close",
              haserror: true,
              scaffoldKey: scaffoldKey,
              isfloating: false,
              onPressed: () {},
              title: e.toString())
          .show();
    }
  }

  void destroyUser() {
    user = null;
    notifyListeners();
  }
}
