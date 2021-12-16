// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/dashboard/viewChalan.dart';
import 'package:e_chalan/src/scan/chalan.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:e_chalan/src/widgets/chalanWidet.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:mailer/mailer.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class PreviousChalan extends StatelessWidget {
  PreviousChalan({
    Key? key,
    this.items = const [],
  }) : super(key: key);

  static const routeName = '/previousChalan';

  final List<Chalan> items;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = 'oesballot';
  String password = '255abcde';

  String smtpServerHost = 'smtp.gmail.com';
  int smtpServerPort = 587;
  bool isSmtpServerSecure = true;
  Future<void> smtpExample() async {
    final client = SmtpClient('gmail.com', isLogEnabled: true);
    try {
      await client.connectToServer(smtpServerHost, smtpServerPort,
          isSecure: isSmtpServerSecure);
      await client.ehlo();
      await client.authenticate(userName, password);
      final builder = MessageBuilder.prepareMultipartAlternativeMessage();
      builder.from = [MailAddress('My name', userName)];
      builder.to = [MailAddress('Your name', "helpyhairy@gmail.com")];
      builder.subject = 'My first message';
      builder.addTextPlain('hello world.');
      builder.addTextHtml('<p>hello <b>world</b></p>');
      final mimeMessage = builder.buildMimeMessage();
      final sendResponse = await client.sendMessage(mimeMessage);
      appLog('message sent: ${sendResponse.isOkStatus}');
    } on SmtpException catch (e) {
      appLog('SMTP failed with $e');
    }
  }

  void sendMail() async {
    String username = 'oesballot@gmail.com';
    String password = '255abcde';

    final smtpServer = gmail(username, password);

    final equivalentMessage = Message()
      ..from = Address(username)
      ..recipients.add(const Address('jemisgoti@gmail.com', 'Jemis Goti'))
      // ..ccRecipients
      //     .addAll([const Address('destCc1@example.com'), 'destCc2@example.com'])
      // ..bccRecipients.add('bccAddress@example.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(equivalentMessage, smtpServer);
      appLog('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      appLog('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: AppTitle(title: 'Previous Chalan'),
        actions: const [],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       // Navigate to the settings page. If the user leaves and returns
        //       // to the app after it has been killed while running in the
        //       // background, the navigation stack is restored.
        //       Navigator.restorablePushNamed(context, SettingsView.routeName);
        //     },
        //   ),
        // ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Padding(
        padding: const EdgeInsets.all(mainMargin),
        child: PaginateFirestore(
          //item builder type is compulsory.
          itemBuilder: (context, documentSnapshots, index) {
            var doc = documentSnapshots[index];
            final data =
                documentSnapshots[index].data() as Map<String, dynamic>;
            Chalan chalan = Chalan.fromJson(data);
            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(chalan.fineTo)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LinearProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    return ProfileTile(
                      context: context,
                      isTwoLine: true,
                      send: false,
                      isverifiyed: false,
                      description: "Ref id :" + doc.id,
                      icon: Icons.card_giftcard,
                      title: data.toString(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewChalan(
                              chalan: chalan,
                              userData: data,
                            ),
                          ),
                        );
                      },
                      value: "Chalan: issued On:"
                          "${DateTime.fromMillisecondsSinceEpoch(chalan.issueDate!.millisecondsSinceEpoch).toString().substring(0, 11)}",
                    );
                  }
                  return ProfileTile(
                    context: context,
                    isTwoLine: true,
                    send: false,
                    isverifiyed: false,
                    description: "Ref id :" + doc.id,
                    icon: Icons.card_giftcard,
                    title: "a",
                    value: "Chalan: issued On:"
                        "${DateTime.fromMillisecondsSinceEpoch(chalan.issueDate!.millisecondsSinceEpoch).toString().substring(0, 11)}",
                  );
                });
          },
          separator: const SizedBox(
            height: mainMargin,
          ),
          // orderBy is compulsory to enable pagination
          query: FirebaseFirestore.instance
              .collection('chalans')
              .where('fineBy',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('issueDate'),
          //Change types accordingly
          itemBuilderType: PaginateBuilderType.listView,
          // to fetch real-time data
          isLive: true, shrinkWrap: true, includeMetadataChanges: false,
          itemsPerPage: 10,
          onEmpty: Column(
            children: const [
              Text(
                'No chalan found',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
