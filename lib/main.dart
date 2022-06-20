import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fotoapp/pages/DoneChallengePage.dart';
import 'package:fotoapp/pages/InspoChallengePage.dart';
import 'package:fotoapp/pages/PhotoChallengePage.dart';
import 'package:fotoapp/pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fotoapp/pages/RegistrationPage.dart';
import 'package:fotoapp/pages/SavedPage.dart';
import 'package:fotoapp/pages/StartPage.dart';
import 'package:fotoapp/pages/UploadPage.dart';
import 'package:fotoapp/pages/UploadedPage.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/AppRoutes.dart';

import 'pages/navpages/MainPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final mainPage = MainPage();
final doneChallengePage = DoneChallengePage();
final inspoChallengePage = InspoChallengePage();
final loginPage = LoginPage();
final photoChallengePage = PhotoChallengePage();
final registrationPage = RegistrationPage();
final savedPage = SavedPage();
final startPage = StartPage();
final uploadedPage = UploadedPage();
final uploadPage = UploadPage();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FotoApp',
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? MainPage()
            : StartPage(),
        routes: <String, WidgetBuilder>{
          AppRoutes.main: (context) => mainPage,
          AppRoutes.doneChallenge: (context) => doneChallengePage,
          AppRoutes.inspoChallenge: (context) => inspoChallengePage,
          AppRoutes.login: (context) => loginPage,
          AppRoutes.photoChallenge: (context) => photoChallengePage,
          AppRoutes.registration: (context) => registrationPage,
          AppRoutes.saved: (context) => savedPage,
          AppRoutes.start: (context) => startPage,
          AppRoutes.uploaded: (context) => uploadedPage,
          AppRoutes.upload: (context) => uploadPage,
        },
        theme: ThemeData(
            hoverColor: AppColors.secundaryColor,
            focusColor: AppColors.backgroundColorYellow,
            shadowColor: AppColors.secundaryColor,
            fontFamily: 'Sora',
            textTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 36.0,
                  color: AppColors.textBlack,
                  fontFamily: 'Sora-Bold'),
              headline2: TextStyle(
                  fontSize: 27.0,
                  color: AppColors.textBlack,
                  fontFamily: 'Sora-Bold'),
              headline3: TextStyle(
                  fontSize: 23.0,
                  color: AppColors.textBlack,
                  fontFamily: 'Sora-Bold'),
              subtitle1: TextStyle(fontSize: 16.0),
              bodyText2: TextStyle(fontSize: 16.0),
              button: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.textBlack,
                  fontFamily: 'Sora-Bold'),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.transparent, elevation: 0.0),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    primary: AppColors.textBlack,
                    shadowColor: AppColors.secundaryColor)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: AppColors.textBlack,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.all(17.0)),
            )));
  }
}
