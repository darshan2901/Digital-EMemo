// ignore_for_file: unused_field, avoid_types_as_parameter_names, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/models/offence.dart';
import 'package:e_chalan/src/providers/dataProvider.dart';
import 'package:e_chalan/src/scan/chalan.dart';
import 'package:e_chalan/src/scan/tickitpass.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/functions.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:e_chalan/src/widgets/Buttons.dart';
import 'package:e_chalan/src/widgets/appbar.dart';
import 'package:e_chalan/src/widgets/inputbox.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:e_chalan/src/widgets/snackbar.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);
  static const routeName = '/scan';
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String _platformVersion = 'Unknown';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterMobileVision.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  static int? cameraOcr = FlutterMobileVision.CAMERA_BACK;
  static bool autoFocusOcr = true;
  static bool torchOcr = false;
  static bool multipleOcr = false;
  static bool waitTapOcr = true;
  static bool showTextOcr = false;
  Size? previewOcr;
  static List<OcrText> textsOcr = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          previewOcr = previewSizes[cameraOcr]!.first;
        }));
  }

  TextEditingController controller = TextEditingController(text: "GJ-05-1926");
  TextEditingController email2 = TextEditingController();
  bool isLoading = false;
  var vehicleData;

  var userData;
  findVehicle() {
    if (controller.text.isEmpty) {
      CustomSnackBar(
              actionTile: "close",
              title: "Please enter the user name",
              haserror: true,
              isfloating: true,
              scaffoldKey: _scaffoldKey)
          .show();
    } else {
      setState(() {
        isLoading = true;
      });

      FirebaseFirestore.instance
          .collection('vehicles')
          .where("number", isEqualTo: controller.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          setState(() {
            isLoading = false;
          });
          CustomSnackBar(
                  actionTile: "close",
                  title: "No Vehicle found",
                  haserror: true,
                  isfloating: true,
                  scaffoldKey: _scaffoldKey)
              .show();
        } else {
          setState(() {
            isLoading = false;
          });
          vehicleData = value.docs.first.data();
          findUser(id: vehicleData['owner']);
          // CustomSnackBar(
          //         actionTile: "close",
          //         title: value.docs.first.data()['owner'],
          //         haserror: false,
          //         isfloating: true,
          //         scaffoldKey: _scaffoldKey)
          //     .show();
        }
      });
    }
  }

  DocumentSnapshot? userDoc;
  PageController pageController = PageController();
  findUser({required String id}) {
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      userDoc = value;
      userData = value.data();
      setState(() {});
      // CustomSnackBar(
      //         actionTile: "city",
      //         title: value.data()!['fname'],
      //         haserror: false,
      //         isfloating: true,
      //         scaffoldKey: _scaffoldKey)
      //     .show();
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      setState(() {
        pageIndex = 1;
      });
    });
  }

  generateChalan() async {
    setState(() {
      isLoading = true;
    });
    chalan = Chalan(
        fineBy: FirebaseAuth.instance.currentUser?.uid,
        fineAmount: offences
            .map((element) {
              return element!.charge;
            })
            .toList()
            .reduce((value, element) => value + element),
        vehicleNumber: controller.text,
        issueDate: Timestamp.now(),
        location: "",
        paymentDone: false,
        offences: offences.map((element) {
          return element!.name;
        }).toList(),
        transactionDate: null,
        fineTo: userDoc!.id);
    FirebaseFirestore.instance
        .collection("chalans")
        .add(chalan!.toJson())
        .then((value) async {
      bool isNewUser = false;

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userData['email'], password: '255abcde');
        isNewUser = true;
      } catch (e) {
        appLog(e);
      }

      await sendChalanMail(
          chalan: chalan!,
          userData: userData!,
          isNewUser: isNewUser,
          newEmail: "newuser",
          newPass: "255abcde",
          smtpData: Provider.of<DataProvider>(context, listen: false).smtpData,
          vehicleData: vehicleData!);

      setState(() {
        isLoading = false;
        pageIndex = 2;
      });
      pageController.animateToPage(2,
          duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
    });
  }

  Chalan? chalan;
  Offence? offence;
  List<Offence?> offences = [];
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> read() async {
    List<OcrText> texts = [];
    Size scanpreviewOcr = previewOcr ?? FlutterMobileVision.PREVIEW;
    try {
      texts = await FlutterMobileVision.read(
        flash: torchOcr,
        autoFocus: autoFocusOcr,
        multiple: multipleOcr,
        waitTap: waitTapOcr,
        //OPTIONAL: close camera after tap, even if there are no detection.
        //Camera would usually stay on, until there is a valid detection
        forceCloseCameraOnTap: true,
        //OPTIONAL: path to save image to. leave empty if you do not want to save the image
        imagePath: '',
        showText: showTextOcr,
        preview: previewOcr ?? FlutterMobileVision.PREVIEW,
        scanArea: Size(scanpreviewOcr.width - 20, scanpreviewOcr.height - 20),
        camera: cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
        fps: 2.0,
      );
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => controller.text = texts.first.value);
  }

  @override
  Widget build(BuildContext context) {
    var data = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(builder: (
      context,
      DataProvider,
      snapshot,
    ) {
      return Scaffold(
        appBar: customAppBar(
            context: context,
            title: pageIndex == 0
                ? 'Scan'
                : pageIndex == 2
                    ? "Chalan generated"
                    : "Generate"),
        // body: getOcrScreen(context),
        backgroundColor: Theme.of(context).canvasColor,
        key: _scaffoldKey,
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.all(mainMargin),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset("assets/images/trafic.svg",
                        width: MediaQuery.of(context).size.width * 0.6,
                        // height: MediaQuery.of(context).size.height * 0.4,
                        semanticsLabel: 'Acme Logo'),
                  ),
                  const SizedBox(height: mainMargin),
                  Text(data.enter_vehicle_number,
                      style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: mainMargin),
                  inputBox(
                    controller: controller,
                    labelText: 'Vehicle Number',
                    error: false,
                    errorText: "Please enter ",
                    ispassword: false,
                    istextarea: false,
                    minLine: 1,
                    obscureText: false,
                    readonly: false,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        read();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const ScanNumberPlat(),
                        //   ),
                        // ).then((value) {
                        //   if (value != null) {
                        //     controller.text = value;
                        //   }
                        // });
                      },
                    ),
                  ),
                  const SizedBox(height: mainMargin),
                  PrimaryButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    borderRadius: radius8,
                    fontsize: 14,
                    isloading: isLoading,
                    foregroundColor: white,
                    height: buttonHeight,
                    onPressed: () {
                      findVehicle();
                    },
                    width: 200,
                    title: "Find User",
                  )
                ],
              ),
            ),
            userData == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(mainMargin),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ProfileTile(
                                context: context,
                                title: "fname",
                                icon: Icons.person,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: (userData!['fname'] +
                                    " " +
                                    userData['mname'] +
                                    " " +
                                    userData!['lname']),
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "email",
                                icon: Icons.email,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: userData!['email'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "vehicle",
                                icon: Icons.email,
                                isTwoLine: false,
                                customWidget: inputBox(
                                  controller: email2,
                                  error: false,
                                  errorText: "Please enter ",
                                  ispassword: false,
                                  istextarea: false,
                                  minLine: 1,
                                  obscureText: false,
                                  readonly: false,
                                  labelText: "Another email",
                                ),
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: vehicleData['type'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "city",
                                icon: Icons.location_city,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: userData!['city'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "state",
                                icon: Icons.location_city,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: userData!['state'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "vehicle",
                                icon: vehicleData['type'] == "two wheeler"
                                    ? Icons.bike_scooter
                                    : Icons.directions_car,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: vehicleData['type'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "vehicle",
                                icon: vehicleData['type'] == "two wheeler"
                                    ? Icons.bike_scooter
                                    : Icons.directions_car,
                                isTwoLine: false,
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: controller.text,
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              ProfileTile(
                                context: context,
                                title: "vehicle",
                                icon: vehicleData['type'] == "two wheeler"
                                    ? Icons.bike_scooter
                                    : Icons.directions_car,
                                isTwoLine: false,
                                customWidget: MultiSelectDialogField<Offence?>(
                                  items: DataProvider.getOffenceByType(
                                          type: vehicleData['type'])
                                      .map((e) => MultiSelectItem(e, e.name))
                                      .toList(),
                                  listType: MultiSelectListType.LIST,
                                  height: 200,
                                  chipDisplay: MultiSelectChipDisplay(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  selectedItemsTextStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  onConfirm: (values) {
                                    offences = values;
                                    setState(() {});
                                  },
                                ),
                                isverifiyed: false,
                                description: "",
                                send: false,
                                value: vehicleData['type'],
                                onTap: () {},
                              ),
                              const SizedBox(height: mainMargin),
                              offences.isEmpty
                                  ? const SizedBox.shrink()
                                  : ProfileTile(
                                      context: context,
                                      title: "email",
                                      icon: Icons.money,
                                      isTwoLine: false,
                                      isverifiyed: false,
                                      description: "",
                                      send: false,
                                      value: "Rs. " +
                                          offences
                                              .map((element) {
                                                return element!.charge;
                                              })
                                              .toList()
                                              .reduce((value, element) =>
                                                  value + element)
                                              .toString() +
                                          "/-",
                                      onTap: () {},
                                    ),
                              offence == null
                                  ? const SizedBox.shrink()
                                  : const SizedBox(height: mainMargin),
                            ],
                          ),
                        ),
                        const SizedBox(height: mainMargin),
                        PrimaryButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          borderRadius: radius8,
                          fontsize: 14,
                          isloading: isLoading,
                          foregroundColor: white,
                          height: buttonHeight,
                          onPressed: () {
                            generateChalan();
                          },
                          width: MediaQuery.of(context).size.width -
                              2 * mainMargin,
                          title: "Generate Chalan",
                        )
                      ],
                    ),
                  ),
            userData == null || chalan == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(mainMargin),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/chalan-done.json',
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                              ),
                              const SizedBox(height: mainMargin),
                              Text("Digital chalan generated successfully",
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(height: mainMargin),
                              SizedBox(
                                width: MediaQuery.of(context).size.width -
                                    2 * mainMargin,
                                child: TicketPass(
                                    alignment: Alignment.center,
                                    animationDuration:
                                        const Duration(seconds: 2),
                                    expandedHeight: offences.length * 147,
                                    expansionChild: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: offences
                                          .map((e) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ProfileTile(
                                                    context: context,
                                                    description: "Rs. " +
                                                        e!.charge.toString() +
                                                        "/-".toString(),
                                                    icon: Icons.list,
                                                    isTwoLine: true,
                                                    isverifiyed: false,
                                                    title: e.name,
                                                    value: e.name,
                                                    send: false,
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                    expandIcon: const CircleAvatar(
                                      maxRadius: 14,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    expansionTitle: const Text(
                                      'Offence',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    purchaserList:
                                        offences.map((e) => e!.name).toList(),
                                    separatorColor: Colors.black,
                                    separatorHeight: 2.0,
                                    color: Colors.white,
                                    curve: Curves.easeOut,
                                    titleColor: Theme.of(context).primaryColor,
                                    shrinkIcon: const Align(
                                      alignment: Alignment.centerRight,
                                      child: CircleAvatar(
                                        maxRadius: 14,
                                        child: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    ticketTitle: const Text(
                                      'Offences',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    titleHeight: 50,
                                    width: 200,
                                    height: 220,
                                    shadowColor: Colors.blue.withOpacity(0.5),
                                    elevation: 8,
                                    shouldExpand: true,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 5),
                                      child: SizedBox(
                                        height: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'First Name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5)),
                                                          ),
                                                          Text(
                                                            userData!['fname'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Last Name',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                          Text(
                                                            userDoc!['lname'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            ' Issue Date',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5)),
                                                          ),
                                                          Text(
                                                            DateTime.fromMillisecondsSinceEpoch(chalan!
                                                                    .issueDate!
                                                                    .millisecondsSinceEpoch)
                                                                .toString()
                                                                .split(' ')[0],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Ammount',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5)),
                                                          ),
                                                          Text(
                                                            'Rs. ' +
                                                                offences
                                                                    .map((e) => e!
                                                                        .charge)
                                                                    .toList()
                                                                    .reduce((a,
                                                                            b) =>
                                                                        a + b)
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: mainMargin),
                        PrimaryButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          borderRadius: radius8,
                          fontsize: 14,
                          isloading: isLoading,
                          foregroundColor: white,
                          height: buttonHeight,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: MediaQuery.of(context).size.width -
                              2 * mainMargin,
                          title: chalan == null ? "Generate Chalan" : "Back",
                        )
                      ],
                    ),
                  )
          ],
        ),
      );
    });
  }
}
