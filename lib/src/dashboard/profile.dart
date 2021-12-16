// ignore_for_file: file_names
import 'package:e_chalan/src/models/appuser.dart';
import 'package:e_chalan/src/onboarding/onboarding.dart';
import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const routeName = '/profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Appuser? user;

  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;
      if (user != null) {
        email.text = user!.email!;
        fname.text = user!.fname!;
        lname.text = user!.lname!;
        city.text = user!.city!;
        state.text = user!.state!;
        country.text = user!.country!;
        // dateOfBirth.text = DateTime.fromMillisecondsSinceEpoch(
        //         user.birthdate.millisecondsSinceEpoch)
        //     .toString()
        //     .substring(0, 10);
      }
      return user == null
          ? const CircularProgressIndicator.adaptive()
          : Scaffold(
              key: scaffoldKey,
              backgroundColor: grey,
              appBar: AppBar(
                title: AppTitle(title: "Profile"),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: mainMargin),
                    child: IconButton(
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: dark,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Onboarding()),
                              (route) => false);
                        });
                      },
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: grey,
                onRefresh: () async {
                  await UserProvider.refreshAuthdata();
                },
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(2 * subMargin),
                              bottomRight: Radius.circular(2 * subMargin))),
                      child: Padding(
                        padding: const EdgeInsets.all(subMargin),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // color: primary,
                                  color: white,
                                  borderRadius:
                                      BorderRadius.circular(subMargin),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(subMargin),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user!.fname! + " " + user!.lname!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: dark),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            !FirebaseAuth.instance.currentUser!
                                                    .emailVerified
                                                ? "Your email is not verified!"
                                                : "Your email is verified",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: dark),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: mainMargin, right: mainMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: mainMargin,
                          ),
                          ProfileTile(
                            context: context,
                            title: "Email",
                            icon: Icons.email_rounded,
                            isverifiyed: true,
                            // FirebaseAuth.instance.currentUser!.emailVerified
                            //     ? true
                            //     : false,
                            send:
                                FirebaseAuth.instance.currentUser!.emailVerified
                                    ? false
                                    : true,
                            value: user!.email,
                          ),
                          const SizedBox(
                            height: mainMargin,
                          ),
                          ProfileTile(
                            title: "Birthdate",
                            context: context,
                            icon: Icons.event,
                            isverifiyed: false,
                            send: false,
                            value: user!.birthdate!
                                .toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 10),
                          ),
                          const SizedBox(
                            height: mainMargin,
                          ),
                          ProfileTile(
                            context: context,
                            title: "Address",
                            icon: Icons.location_city,
                            isverifiyed: false,
                            send: false,
                            value: user!.city! +
                                ", " +
                                user!.state! +
                                ", " +
                                user!.country!,
                          ),
                          const SizedBox(
                            height: mainMargin,
                          ),
                          FutureBuilder<PackageInfo>(
                              future: PackageInfo.fromPlatform(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String version = snapshot.data!.version;
                                  String buildNumber =
                                      snapshot.data!.buildNumber;
                                  return Center(
                                      child: Text(
                                    "Version:$version ($buildNumber)",
                                    style: eventtitle,
                                  ));
                                }
                                return const Center(
                                  child: Text("Loading..."),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ));
    });
  }
}
