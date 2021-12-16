import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  String? title;
  Loading({this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                backgroundColor: white,
              )),
          Padding(
            padding: EdgeInsets.only(top: mainMarginHalf),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )
        ],
      ),
    ));
  }
}

class NoData extends StatelessWidget {
  String? title;
  NoData({this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 300,
              child: Image.asset(
                'assets/nodata.png',
                fit: BoxFit.fitHeight,
              )),
          Padding(
            padding: EdgeInsets.only(top: mainMarginHalf),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )
        ],
      ),
    ));
  }
}
