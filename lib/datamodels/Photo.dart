import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fotoapp/datamodels/Rating.dart';
import 'package:fotoapp/datamodels/Userdb.dart';

class Photo {
  String id;
  final String photoChallengeID;
  final String photoUrl;
  final String userID;
  final Map<String, dynamic>? ratings;

  Photo({
    this.id = '',
    required this.photoChallengeID,
    required this.photoUrl,
    required this.userID,
    this.ratings,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'photoChallengeID': photoChallengeID,
        'photoUrl': photoUrl,
        'userID': userID,
        'ratings': ratings,
      };

  static Photo fromJson(Map<String, dynamic> json) => Photo(
      id: json['id'],
      photoChallengeID: json['photoChallengeID'],
      photoUrl: json['photoUrl'],
      userID: json['userID'],
      ratings: json['ratings']);
}
