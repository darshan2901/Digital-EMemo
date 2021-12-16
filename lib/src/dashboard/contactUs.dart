// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/widgets/appbar.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);
  static const routeName = '/contactUs';

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            customAppBar(context: context, isBack: true, title: 'Contact Us'),
        backgroundColor: Theme.of(context).canvasColor,
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('contacts').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = snapshot.data!.docs;
                return ListView.separated(
                    itemCount: docs.length,
                    padding: const EdgeInsets.all(mainMargin),
                    itemBuilder: (context, index) {
                      return ProfileTile(
                          context: context,
                          title: "Role",
                          icon: docs[index]['type'] == "email"
                              ? Icons.email
                              : Icons.phone,
                          isverifiyed: false,
                          send: false,
                          value: docs[index]['value']);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: mainMargin);
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
