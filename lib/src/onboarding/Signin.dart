// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/onboarding/ForgotPass.dart';
import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/providers/dataProvider.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:e_chalan/src/widgets/Buttons.dart';
import 'package:e_chalan/src/widgets/inputbox.dart';
import 'package:e_chalan/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static const routeName = '/signin';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController? email, pass;
  bool email_error = false, pass_error = false;
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    email = TextEditingController();
    pass = TextEditingController();
    super.initState();
  }

  void sigin(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!.text, password: pass!.text);
      appLog("login");
      appLog(userCredential);
      appLog("user instance");
      // appLog(userCredential.user);

      Provider.of<UserProvider>(context, listen: false)
          .fetchLogedUser(cntx: context)
          .then((value) {});
      Provider.of<DataProvider>(context, listen: false).getOffence();
      Provider.of<DataProvider>(context, listen: false).getSmtpData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          email_error = true;
          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "No user found for this email!")
              .show();
        });
        appLog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        isloading = false;
        pass_error = true;
        setState(() {
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "Wrong password provided for this user!")
              .show();
        });
        appLog('Wrong password provided for that user.');
      } else {
        isloading = false;
        pass_error = true;
        appLog(e.code);
        setState(() {
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: e.code)
              .show();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black,
            size: mainMargin + 6,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(mainMargin),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    color: dark, fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(
                height: mainMargin,
              ),
              const Text(
                "Enter your email address!",
                style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w400,
                    fontSize: subMargin + 4),
              ),
              const SizedBox(
                height: 2 * mainMargin,
              ),
              inputBox(
                controller: email,
                error: email_error,
                errorText: "",
                inuptformat: const [],
                labelText: "Email Address",
                obscureText: false,
                ispassword: false,
                istextarea: false,
                readonly: false,
                onchanged: (value) {
                  setState(() {
                    email_error = false;
                  });
                },
              ),
              const SizedBox(
                height: mainMargin,
              ),
              inputBox(
                controller: pass,
                error: pass_error,
                errorText: "",
                inuptformat: [],
                labelText: "Password",
                readonly: false,
                obscureText: true,
                ispassword: true,
                istextarea: false,
                onchanged: (value) {
                  setState(() {
                    pass_error = false;
                  });
                },
              ),
              const SizedBox(
                height: mainMargin,
              ),
              Hero(
                tag: 'button',
                child: PrimaryButton(
                  isloading: isloading,
                  onPressed: () {
                    if (email!.text == '') {
                      appLog("email null");
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title: "Please enter your email!")
                            .show();
                        email_error = true;
                      });
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email!.text)) {
                      print("not  email");
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title: "Please enter valid email!")
                            .show();
                        email_error = true;
                      });
                    } else if (pass!.text == '') {
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title: "Please enter your password!")
                            .show();

                        pass_error = true;
                      });
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      appLog("calling signin");
                      sigin(context);
                    }
                  },
                  title: "Login",
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: white,
                  height: 50,
                ),
              ),
              const SizedBox(
                height: mainMargin,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPass()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: mainMargin - 2, fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
