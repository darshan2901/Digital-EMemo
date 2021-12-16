import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(
    {required BuildContext context,
    String? title,
    bool isBack = true,
    List<Widget>? actions}) {
  return AppBar(
    title: AppTitle(title: title),
    automaticallyImplyLeading: isBack,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
    actions: actions,
  );
}
