import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  login(email, password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  create(email, password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  logout() async {
    await auth.signOut();
  }

  bool isLoggedIn() {
    if (auth.currentUser! != null) {
      return true;
    } else {
      return false;
    }
  }

  String getUserId() {
    final currentUser = auth.currentUser;
    final userId = currentUser?.uid;

    if (userId != null) {
      return userId;
    } else {
      return '';
    }
  }

  String getCurrentUserEmail() {
    final userEmail = auth.currentUser?.email.toString();
    if (userEmail != null) {
      return userEmail;
    } else {
      return '';
    }
  }
}
