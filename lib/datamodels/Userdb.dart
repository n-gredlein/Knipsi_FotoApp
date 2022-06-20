import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fotoapp/datamodels/Rating.dart';

class Userdb {
  final String name;
  final String email;

  Userdb({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };

  static Userdb fromJson(Map<String, dynamic> json) => Userdb(
        name: json['name'],
        email: json['email'],
      );
}
