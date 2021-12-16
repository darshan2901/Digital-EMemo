// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chalan/src/models/offence.dart';
import 'package:e_chalan/src/providers/dataProvider.dart';
import 'package:e_chalan/src/scan/chalan.dart';
import 'package:e_chalan/src/scan/tickitpass.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:e_chalan/src/widgets/Buttons.dart';
import 'package:e_chalan/src/widgets/appbar.dart';
import 'package:e_chalan/src/widgets/profileTile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class ViewChalan extends StatefulWidget {
  ViewChalan({Key? key, required this.chalan, this.userData}) : super(key: key);

  static const routeName = '/viewChalan';

  var userData;
  Chalan chalan;

  @override
  State<ViewChalan> createState() => _ViewChalanState();
}

class _ViewChalanState extends State<ViewChalan> {
  List<Offence?> offences = [];
  bool isLoading = true;
  var vehicleData;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState\
    getData();
    super.initState();
  }

  getData() async {
    appLog(widget.chalan.vehicleNumber);
    FirebaseFirestore.instance
        .collection('vehicles')
        .where('number', isEqualTo: widget.chalan.vehicleNumber)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        vehicleData = value.docs.first.data();
        if (vehicleData['type'] == "two wheeler") {
          var of =
              Provider.of<DataProvider>(context, listen: false).twoWheelerMap;

          for (var element in widget.chalan.offences!) {
            offences.add(of[element]);
          }
        } else if (vehicleData['type'] == "four wheeler") {
          var of =
              Provider.of<DataProvider>(context, listen: false).fourWheelerMap;
          for (var element in widget.chalan.offences!) {
            offences.add(of[element]);
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Chalan Details'),
      body: Padding(
        padding: const EdgeInsets.all(mainMargin),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const SizedBox(
                      height: 90,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width -
                              2 * mainMargin,
                          child: TicketPass(
                              alignment: Alignment.center,
                              animationDuration: const Duration(seconds: 2),
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'First Name',
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    Text(
                                                      widget.userData!['fname'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Name',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.userData!['lname'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      ' Issue Date',
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    Text(
                                                      DateTime.fromMillisecondsSinceEpoch(
                                                              widget
                                                                  .chalan
                                                                  .issueDate!
                                                                  .millisecondsSinceEpoch)
                                                          .toString()
                                                          .split(' ')[0],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Ammount',
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    Text(
                                                      'Rs. ' +
                                                          offences
                                                              .map((e) =>
                                                                  e!.charge)
                                                              .toList()
                                                              .reduce((a, b) =>
                                                                  a + b)
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
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
              isloading: false,
              foregroundColor: white,
              height: buttonHeight,
              onPressed: () {
                Navigator.pop(context);
              },
              width: MediaQuery.of(context).size.width - 2 * mainMargin,
              title: "Back",
            )
          ],
        ),
      ),
    );
  }
}
