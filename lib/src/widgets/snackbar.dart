import 'package:e_chalan/src/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  GlobalKey<ScaffoldState>? scaffoldKey;
  bool? haserror = false;
  String? title, actionTile;
  Function? onPressed;
  bool? isfloating;

  CustomSnackBar(
      {this.scaffoldKey,
      this.title,
      this.haserror,
      this.actionTile,
      this.isfloating,
      this.onPressed});

  void show() {
    scaffoldKey!.currentState!.showSnackBar(SnackBar(
      content: Text(
        title!,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: haserror!
          ? errorColor
          : Theme.of(scaffoldKey!.currentState!.context).primaryColor,
      behavior:
          isfloating! ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: isfloating! ? EdgeInsets.all(20) : null,
      duration: Duration(seconds: 2),
      action: actionTile != ""
          ? SnackBarAction(
              label: actionTile!,
              onPressed: onPressed == null
                  ? () {
                      scaffoldKey!.currentState!.hideCurrentSnackBar();
                    }
                  : onPressed as void Function(),
              textColor: white,
            )
          : null,
    ));
  }
}
