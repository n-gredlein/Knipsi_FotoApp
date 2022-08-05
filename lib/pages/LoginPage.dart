import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/pages/navpages/MainPage.dart';
import '../services/AuthService.dart';
import '../services/DatabaseService.dart';
import '../widgets/Button1.dart';

DatabaseService service = DatabaseService();

AuthService authservice = AuthService();

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 213, 92)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 220, right: 10, bottom: 10),
                child:
                    Text("Login", style: Theme.of(context).textTheme.headline1),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.textGrey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'E-Mail',
                    prefixIcon: Icon(
                      FeatherIcons.mail,
                      color: AppColors.textGrey,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.textGrey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Passwort',
                    prefixIcon: Icon(
                      FeatherIcons.lock,
                      color: AppColors.textGrey,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Button1(
                text: 'Login',
                width: double.infinity,
                color: AppColors.primaryColor,
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  authservice.login(email, password);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
