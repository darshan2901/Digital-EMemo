import 'package:e_chalan/src/dashboard/calender.dart';
import 'package:e_chalan/src/dashboard/contactUs.dart';
import 'package:e_chalan/src/dashboard/emmergency.dart';
import 'package:e_chalan/src/dashboard/scan.dart';
import 'package:e_chalan/src/settings/settings_view.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/functions.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    var data = [
      {
        "title": "Scan",
        "icon": Icons.camera_alt,
        "routeName": Scan.routeName,
      },
      {
        "title": "Calender",
        "icon": Icons.calendar_today,
        "routeName": Calender.routeName,
      },
      {
        "title": "Emmergency",
        "icon": Icons.help,
        "routeName": Emmergency.routeName,
      },
      {
        "title": "Contact us",
        "icon": Icons.contact_mail,
        "routeName": ContactUs.routeName,
      }
    ];
    return Scaffold(
        appBar: AppBar(
          title: AppTitle(title: 'Dashboard'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).canvasColor,
        body: Container(
          padding: const EdgeInsets.all(mainMargin),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: mainMargin,
              mainAxisSpacing: mainMargin,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius16),
                ),
                child: InkWell(
                  onTap: () {
                    restorablePushNamed(
                        context: context,
                        routeName: data[index]['routeName'] as String);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        data[index]['icon'] as IconData,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        height: mainMargin,
                      ),
                      Text(
                        data[index]['title'] as String,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
