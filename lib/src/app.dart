// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:e_chalan/src/dashboard/calender.dart';
import 'package:e_chalan/src/dashboard/contactUs.dart';
import 'package:e_chalan/src/dashboard/dashBoard.dart';
import 'package:e_chalan/src/dashboard/emmergency.dart';
import 'package:e_chalan/src/dashboard/history.dart';
import 'package:e_chalan/src/dashboard/profile.dart';
import 'package:e_chalan/src/dashboard/scan.dart';
import 'package:e_chalan/src/onboarding/Signin.dart';
import 'package:e_chalan/src/onboarding/onboarding.dart';
import 'package:e_chalan/src/onboarding/splashScreen.dart';
import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/providers/appTheme.dart';
import 'package:e_chalan/src/providers/dataProvider.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    // required this.settingsController,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (_) => UserProvider(cntx: context)),
          ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),
          ChangeNotifierProvider<DataProvider>(
              create: (_) => DataProvider(cntx: context)),
        ],
        builder: (context, child) {
          return Consumer<AppTheme>(builder: (context, AppTheme, snapshot) {
            return MaterialApp(
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',
              debugShowCheckedModeBanner: false,
              // Provide the generated AppLocalizations to the MaterialApp. This
              // allows descendant Widgets to display the correct translations
              // depending on the user's locale.
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
              ],

              // Use AppLocalizations to configure the correct application title
              // depending on the user's locale.
              //
              // The appTitle is defined in .arb files found in the localization
              // directory.
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,

              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: ThemeData(
                  scaffoldBackgroundColor: white,
                  primaryColor: primaryColor,
                  primaryColorDark: darkColor,
                  canvasColor: grey,
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    backgroundColor: transparent,
                  )),
              darkTheme: ThemeData(
                  scaffoldBackgroundColor: white,
                  primaryColor: primaryColor,
                  primaryColorDark: darkColor,
                  canvasColor: grey,
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    backgroundColor: transparent,
                  )),
              themeMode: AppTheme.themeMode,

              // Define a function to handle named routes in order to support
              // Flutter web url navigation and deep linking.
              onGenerateRoute: (RouteSettings routeSettings) {
                return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    switch (routeSettings.name) {
                      case Onboarding.routeName:
                        return const Onboarding();
                      case SplashScreen.routeName:
                        return const SplashScreen();
                      case SignIn.routeName:
                        return const SignIn();
                      case SettingsView.routeName:
                        return const SettingsView();
                      case PreviousChalan.routeName:
                        return PreviousChalan();
                      case Scan.routeName:
                        return const Scan();
                      case ProfilePage.routeName:
                        return const ProfilePage();
                      case Dashboard.routeName:
                        return const Dashboard();
                      case Emmergency.routeName:
                        return const Emmergency();
                      case Calender.routeName:
                        return const Calender();
                      case ContactUs.routeName:
                        return const ContactUs();
                      default:
                        return const SplashScreen();
                    }
                  },
                );
              },
              home: const SplashScreen(),
            );
          });
        });
  }
}
