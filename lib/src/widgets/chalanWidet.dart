// ignore_for_file: file_names

import 'package:e_chalan/src/dashboard/viewChalan.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:flutter/material.dart';

class ChalanWidget extends StatelessWidget {

  const ChalanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(subMargin),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.01),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
      child: ListTile(
          title: const Text("fs"),
          leading: const CircleAvatar(
            // Display the Flutter Logo image asset.
            foregroundImage: AssetImage('assets/images/flutter_logo.png'),
          ),
          onTap: () {
            // Navigate to the details page. If the user leaves and returns to
            // the app after it has been killed while running in the
            // background, the navigation stack is restored.
            Navigator.restorablePushNamed(
              context,
              ViewChalan.routeName,
            );
          }),
    );
  }
}
