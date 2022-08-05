import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fotoapp/datamodels/Photo.dart';
import 'package:fotoapp/datamodels/Userdb.dart';

class PhotoChallenge {
  String id;
  final String title;
  final String shortDescription;
  final String description;
  final String tipp;
  final String categoryId;
  final String titlePhoto;
  List<dynamic>? usersDone;
  List<dynamic>? usersSaved;

  PhotoChallenge({
    this.id = '',
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.tipp,
    required this.categoryId,
    required this.titlePhoto,
    this.usersDone,
    this.usersSaved,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'shortDescription': shortDescription,
        'description': description,
        'tipp': tipp,
        'categoryId': categoryId,
        'photo': titlePhoto,
        'usersDone': usersDone,
        'usersSaved': usersSaved,
      };

  static PhotoChallenge fromJson(Map<String, dynamic> json) => PhotoChallenge(
      id: json['id'],
      title: json['title'],
      shortDescription: json['shortDescription'],
      description: json['description'],
      tipp: json['tipp'],
      titlePhoto: json['titlePhoto'],
      categoryId: json['categoryId'],
      usersDone: json['usersDone'],
      usersSaved: json['usersSaved']);
}
