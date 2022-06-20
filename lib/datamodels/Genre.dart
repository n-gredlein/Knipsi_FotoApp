import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fotoapp/datamodels/Userdb.dart';

class Genre {
  String id;
  final String name;

  Genre({
    this.id = '',
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  static Genre fromJson(Map<String, dynamic> json) => Genre(
        id: json['id'],
        name: json['name'],
      );
}
