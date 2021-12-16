// ignore_for_file: file_names
import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTile extends StatelessWidget {
  String? title, value, description;
  IconData? icon;
  bool? isverifiyed, send;
  BuildContext context;
  bool isTwoLine = false;
  Function? onTap;
  Widget? customWidget;
  ProfileTile(
      {Key? key,
      this.title,
      this.customWidget,
      this.icon,
      this.send,
      this.description,
      required this.context,
      this.value,
      this.isTwoLine = false,
      this.isverifiyed,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: subMargin),
        decoration: BoxDecoration(
            color: white,
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
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(subMarginHalf),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(radius32)),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColorDark,
                  )),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          title: customWidget ?? Text(value!),
          subtitle: isTwoLine ? Text(description!) : null,
          minLeadingWidth: subMargin,
          dense: true,
          trailing: isverifiyed!
              ? Icon(
                  Icons.verified_rounded,
                  color: Theme.of(context).primaryColor,
                )
              : send!
                  ? InkWell(
                      onTap: () {
                        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                          UserProvider.sendVerificationemail();
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    )
                  : const SizedBox.shrink(),
          // subtitle: Text(value),
        ),
      );
    });
  }
}
