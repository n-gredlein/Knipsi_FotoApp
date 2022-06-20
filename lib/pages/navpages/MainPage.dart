import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:fotoapp/AppColors.dart';

import 'package:fotoapp/pages/navpages/HomePage.dart';
import 'package:fotoapp/pages/navpages/InspirationPage.dart';
import 'package:fotoapp/pages/navpages/UserPage.dart';
import 'package:fotoapp/widgets/AppBarTop.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [HomePage(), InspirationPage(), UserPage()];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentIndex],

        //backgroundColor: Colors.grey,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 0.5))
            ],
          ),
          child: SnakeNavigationBar.color(
              elevation: 2,
              shadowColor: AppColors.secundaryColor,
              onTap: onTap,
              //type: BottomNavigationBarType.shifting,
              currentIndex: currentIndex,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.textBlack,
              unselectedItemColor: AppColors.textBlack,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              snakeViewColor: AppColors.primaryColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.aperture), label: 'Inspiration'),
                BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.user), label: 'User'),
              ]),
        ));
  }
}
