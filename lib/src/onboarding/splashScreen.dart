// ignore_for_file: file_names

import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/providers/dataProvider.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      Provider.of<UserProvider>(context, listen: false)
          .fetchLogedUser(cntx: context);
             Provider.of<DataProvider>(context, listen: false)
          .getOffence( );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mainMargin, vertical: 0),
              child: SizedBox(width: 200, child: LinearProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
