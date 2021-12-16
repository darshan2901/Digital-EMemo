import 'package:e_chalan/src/theme/colors.dart';
import 'package:flutter/cupertino.dart';

const double mainMargin = 16;
const double mainMarginHalf = 8;
const double mainMarginDouble = 32;
const double subMargin = 12;
const double subMarginHalf = 6;
const double subMarginDouble = 24;

const double radius32 = 32;
const double radius16 = 16;
const double radius8 = 8;
const double radius4 = 4;

double buttonRadius = 8; 
double buttonHeight = 50;

const TextStyle eventtitle =
    TextStyle(color: dark, fontWeight: FontWeight.w600, fontSize: 18);
  TextStyle eventsubtitle = TextStyle(
    color: dark.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 14);
  TextStyle onbsubttile = TextStyle(
    color: dark.withOpacity(0.55), fontWeight: FontWeight.w400, fontSize: 18); 
class AppTitle extends StatelessWidget {
  String? title;
  AppTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
    );
  }
}
