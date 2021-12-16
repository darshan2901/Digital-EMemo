import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/widgets/appbar.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Emmergency extends StatefulWidget {
  const Emmergency({Key? key}) : super(key: key);
  static const routeName = '/emmergency';

  @override
  _EmmergencyState createState() => _EmmergencyState();
}

class _EmmergencyState extends State<Emmergency> {
  updateColec() {
    FirebaseFirestore.instance.collection('emergency').get().then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance.collection("emergency").add(element.data());
      }
    });
  }

  deleteDoc({required String id}) {
    FirebaseFirestore.instance.collection('emergency').doc(id).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    // updateColec();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            customAppBar(context: context, isBack: true, title: 'Emergency'),
        backgroundColor: Theme.of(context).canvasColor,
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('emergency')
                .orderBy('department')
                .get(),
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
                          onTap: () {
                            // deleteDoc(id: docs[index].id);
                          },
                          icon: docs[index]['type'] == "email"
                              ? Icons.email
                              : Icons.phone,
                          isverifiyed: false,
                          isTwoLine: true,
                          description: docs[index]['value'],
                          send: false,
                          value: docs[index]['department']);
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
