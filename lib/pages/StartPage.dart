import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';

import '../AppRoutes.dart';
import '../widgets/Button1.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 255, 213, 92),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200, bottom: 200),
            child: Image(
                height: 200,
                image: AssetImage("assets/images/LogoWithName_downwards.png")),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Button1(
                    text: "Login",
                    color: AppColors.backgroundColorWhite,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Button1(
                    text: "Registrieren",
                    color: AppColors.primaryColor,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.registration),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
