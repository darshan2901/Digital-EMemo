import 'dart:ui';

import 'package:e_chalan/src/onboarding/Signin.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:e_chalan/src/theme/constants.dart';
import 'package:e_chalan/src/utility/functions.dart';
import 'package:e_chalan/src/utility/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);
  static const routeName = '/onboarding';
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    var data = AppLocalizations.of(context)!;
    var onb = [
      {
        "title": data.onbtitle1,
        "description": data.onbdesc1,
        "icon": Icons.document_scanner
      },
      {
        "title": data.onbtitle2,
        "description": data.onbdesc2,
        "icon": Icons.file_copy
      },
      {
        "title": data.onbtitle3,
        "description": data.onbdesc3,
        "icon": Icons.security_rounded
      }
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/traffic.png'),
            fit: BoxFit.cover,
          ),
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //   Color(0xFFF8F8F8),
          //   Color(0xFFF8F8F8),
          //   Color(0xFFF8F8F8),
          // ])
        ),
        // color: Theme.of(context).primaryColor,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(0.75),
            padding: const EdgeInsets.all(mainMargin),
            child: Column(
              children: [
                const Spacer(),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(radius32),
                      ),
                      padding: const EdgeInsets.all(subMargin),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: mainMargin),
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: controller,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        width: 80,
                                        child: Center(
                                          child: Icon(
                                              onb[index]["icon"] as IconData,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                        ),
                                      ),
                                      const SizedBox(height: mainMargin),
                                      Text(
                                        onb[index]["title"].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(fontSize: 32),
                                      ),
                                      const SizedBox(height: mainMargin),
                                      Text(
                                        onb[index]["description"].toString(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 18, color: dark),
                                      ),
                                    ],
                                  );
                                },
                                itemCount: onb.length,
                              ),
                            ),
                            const SizedBox(height: subMarginDouble),
                            SmoothPageIndicator(
                                controller: controller, // PageController
                                count: 3,
                                effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    expansionFactor: 3,
                                    activeDotColor: Theme.of(context)
                                        .primaryColor), // your preferred effect
                                onDotClicked: (index) {}),
                            const SizedBox(height: mainMargin + subMarginHalf),
                            FloatingActionButton(
                              onPressed: () {
                                appLog("Going forward");
                                if (controller.page == 2) {
                                  restorablePushNamed(
                                      context: context,
                                      routeName: SignIn.routeName);
                                } else {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                }
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.arrow_forward),
                            )
                          ])

                      //  Column(
                      //   children: [

                      //     // PageView(
                      //     //   children:  AppLocalizations.of(context)!.onboarding.map((e) => Text(e,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),)).toList(),
                      //     // )
                      //   ],
                      // ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
