// ignore_for_file: deprecated_member_use

import 'package:e_chalan/src/scan/chalan.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

restorablePushNamed(
    {required BuildContext context,
    required String routeName,
    Object? arguments}) {
  Navigator.restorablePushNamed(
    context,
    routeName,
    arguments: arguments,
  );
}

nonReplaceblePushNamed(
    {required BuildContext context,
    required String routeName,
    Object? arguments}) {
  Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
}

Future<bool> sendChalanMail(
    {var smtpData,
    String? newEmail,
    String? newPass,
    Chalan? chalan,
    var userData,
    var vehicleData,
    bool isNewUser = false}) async {
  var rt = false;
  var smtpServer = gmail(smtpData['email'], smtpData['apppaswrod']);
  var message = Message()
    ..from = Address(smtpData['email'], 'E-Chalan')
    ..recipients.add("jemisgoti@gmail.com")
    ..subject = 'E-chalan for traffic rule violation'
    ..text =
        'Hello,\n\nYou have violated the traffic rule.here is the didgital chalan for ' +
            chalan!.offences!.join(", ") +
            ". Total payeble amount is " +
            chalan.fineAmount!.toString() +
            " INR. " +
            (isNewUser == true
                ? "your username is $newEmail) and password is $newPass. \nPlease reset password after login. "
                : "") +
            "\nThank You";
  if (isNewUser) {
    message.subject = 'Chalan';
    message.text = 'Chalan';
  }
  try {
    await send(message, smtpServer).then((_) {
      appLog("Email sent!");
      rt = true;
    }).catchError((e) {
      appLog("Error sending email.");
      appLog(e);
    });
  } catch (e) {
    appLog('Error: $e');
  }
  return rt;
}
