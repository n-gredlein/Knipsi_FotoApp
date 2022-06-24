import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datamodels/Photo.dart';
import '../datamodels/Userdb.dart';
import '../services/AuthService.dart';
import '../services/DatabaseService.dart';
import '../widgets/Button1.dart';
import '../widgets/Textfield1.dart';
import 'navpages/MainPage.dart';

DatabaseService service = DatabaseService();
AuthService authservice = AuthService();
final auth = FirebaseAuth.instance;

final emailController = TextEditingController();
final nameController = TextEditingController();
final passwordController = TextEditingController();

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                    EdgeInsets.only(left: 10, top: 100, right: 10, bottom: 10),
                child: Text("Registrierung",
                    style: Theme.of(context).textTheme.headline1),
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
                height: 60,
              ),
              TextField(
                  controller: nameController,
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
                    hintText: 'Benutzername',
                    prefixIcon: Icon(
                      FeatherIcons.user,
                      color: AppColors.textGrey,
                    ),
                  )),
              SizedBox(
                height: 10,
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
                text: 'Registrieren',
                width: double.infinity,
                color: AppColors.primaryColor,
                onPressed: () {
                  final email = emailController.text;
                  final name = nameController.text;
                  final password = passwordController.text;
                  final currentChallenge = 0;

                  final userdb = Userdb(
                      name: name,
                      email: email,
                      currentChallenge: currentChallenge);
                  authservice.create(email, password);
                  service.createUser(userdb);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
              )
            ],
          ),
        )
      ],
    ));
  }
}
