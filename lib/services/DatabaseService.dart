import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';

import 'package:fotoapp/datamodels/Userdb.dart';
import 'package:fotoapp/pages/SavedPage.dart';
import 'package:fotoapp/services/AuthService.dart';

import '../datamodels/Photo.dart';
import '../datamodels/Genre.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /**********User**********/
  Future createUser(Userdb userdb) async {
    final docUser = _db.collection('users').doc(userdb.email);
    final json = userdb.toJson();
    await docUser.set(json);
  }

  Stream<List<Userdb>> readUsers() =>
      _db.collection('users').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Userdb.fromJson(doc.data())).toList());

  /* Future<Userdb?> readUser(String docId) async {
    final docUser = _db.collection('users').doc(docId);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Userdb.fromJson(snapshot.data()!);
    }
  }*/

  Stream<List<Userdb>> readUser() => _db
      .collection('users')
      .where('email', isEqualTo: authService.getCurrentUserEmail())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Userdb.fromJson(doc.data())).toList());

  Future updateUser(String userId, Map<String, Object?> data) async {
    final docUser = _db.collection('users').doc(userId);
    docUser.update(data);
  }

  Future deleteUser(String userId) async {
    final docUser = _db.collection('users').doc(userId);
    docUser.delete();
  }

  /***********Photos**********/
  Future createPhoto(Photo photo) async {
    final docPhoto = _db.collection('photos').doc();

    photo.id = docPhoto.id;
    final json = photo.toJson();

    await docPhoto.set(json);
  }

  Stream<List<Photo>> readPhotosGenreFilter(List filters) => _db
      .collection('photos')
      .where('genreID', whereIn: filters)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Photo.fromJson(doc.data())).toList());

  Stream<List<Photo>> readPhotos() =>
      _db.collection('photos').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Photo.fromJson(doc.data())).toList());

  Stream<List<Photo>> readPhotosPhotoChallenge(String photoChallengeId) => _db
      .collection('photos')
      .where('photoChallengeID', isEqualTo: photoChallengeId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Photo.fromJson(doc.data())).toList());

  Future<Photo?> readPhoto(String docId) async {
    final docPhoto = _db.collection('photos').doc(docId);
    final snapshot = await docPhoto.get();
    if (snapshot.exists) {
      return Photo.fromJson(snapshot.data()!);
    }
  }

  Stream<List<Photo>> readPhotoByPhotoChallengeId(String docId) => _db
      .collection('photos')
      .where('photoChallengeID', isEqualTo: docId)
      .where('userID', isEqualTo: authService.getCurrentUserEmail())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Photo.fromJson(doc.data())).toList());

  Future updatePhoto(String photoId, Map<String, Object?> data) async {
    final docPhoto = _db.collection('photos').doc(photoId);
    docPhoto.update(data);
  }

  Future deletePhoto(String photoId) async {
    final docPhoto = _db.collection('photos').doc(photoId);
    docPhoto.delete();
  }

  /**********PhotoChallenges**********/
  Future createPhotoChallenge(PhotoChallenge photoChallenge) async {
    final docPhoto = _db.collection('photoChallenges').doc();

    photoChallenge.id = docPhoto.id;
    final json = photoChallenge.toJson();

    await docPhoto.set(json);
  }

  Stream<List<PhotoChallenge>> readPhotoChallenges() => _db
      .collection('photoChallenges')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PhotoChallenge.fromJson(doc.data()))
          .toList());

  Stream<List<PhotoChallenge>> readPhotoChallengesGenre(String genreId) => _db
      .collection('photoChallenges')
      .where('genre', isEqualTo: genreId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PhotoChallenge.fromJson(doc.data()))
          .toList());

  Future<PhotoChallenge?> readPhotoChallenge(String docId) async {
    final docPhotoChallenge = _db.collection('photoChallenges').doc(docId);
    final snapshot = await docPhotoChallenge.get();
    if (snapshot.exists) {
      return PhotoChallenge.fromJson(snapshot.data()!);
    }
  }

  /* Stream<PhotoChallenge?> readPhotoChallenge(String docId)  async {
    final docPhotoChallenge = await  _db.collection('photoChallenges').doc(docId).get();
 PhotoChallenge.fromJson(docPhotoChallenge.data());
    
      return Future.PhotoChallenge.fromJson(snapshot.data()!);
  
  }*/

  Stream<List<PhotoChallenge>> readPhotoChallengeId(String docId) => _db
      .collection('photoChallenges')
      .where('id', isEqualTo: docId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PhotoChallenge.fromJson(doc.data()))
          .toList());

  Future updatePhotoChallenge(
      String photoChallengeId, Map<String, Object?> data) async {
    final docPhotoChallenge =
        _db.collection('photoChallenges').doc(photoChallengeId);
    docPhotoChallenge.update(data);
  }

  Future deletePhotoChallenge(String photoChallengeId) async {
    final docPhotoChallenge =
        _db.collection('photoChallenges').doc(photoChallengeId);
    docPhotoChallenge.delete();
  }

  /**********Categories**********/
  Future createGenre(Genre genre) async {
    final docGenre = _db.collection('genres').doc();

    genre.id = docGenre.id;
    final json = genre.toJson();

    await docGenre.set(json);
  }

  Stream<List<Genre>> readGenres() =>
      _db.collection('genres').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Genre.fromJson(doc.data())).toList());

  Future<Genre?> readGenre(String docId) async {
    final docGenre = _db.collection('categories').doc(docId);
    final snapshot = await docGenre.get();
    if (snapshot.exists) {
      return Genre.fromJson(snapshot.data()!);
    }
  }

  Future updateGenre(String genreId, Map<String, Object?> data) async {
    final docGenre = _db.collection('genres').doc(genreId);
    docGenre.update(data);
  }

  Future deleteGenre(String genreId) async {
    final docGenre = _db.collection('genres').doc(genreId);
    docGenre.delete();
  }

  /**********SavedChallenges***********/
  Stream<List<PhotoChallenge>> readSavedPhotoChallenges(
          String currentUserEmail) =>
      _db
          .collection('photoChallenges')
          .where('usersSaved', arrayContains: currentUserEmail)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PhotoChallenge.fromJson(doc.data()))
              .toList());

  Future addSavedPhotoChallenge(String photoChallengeId) async {
    final docUser = _db.collection('photoChallenges').doc(photoChallengeId);
    docUser.update({
      'usersSaved': FieldValue.arrayUnion([authService.getCurrentUserEmail()])
    });
  }

  Future removeSavedPhotoChallenge(String photoChallengeId) async {
    final docUser = _db.collection('photoChallenges').doc(photoChallengeId);
    docUser.update({
      'usersSaved': FieldValue.arrayRemove([authService.getCurrentUserEmail()])
    });
  }

  /**********DoneChallenges***********/
  Future addDonePhotoChallenge(String photoChallengeId) async {
    final docUser = _db.collection('photoChallenges').doc(photoChallengeId);
    docUser.update({
      'usersDone': FieldValue.arrayUnion([authService.getCurrentUserEmail()])
    });
  }

  Future removeDonePhotoChallenge(String photoChallengeId) async {
    final docUser = _db.collection('photoChallenges').doc(photoChallengeId);
    docUser.update({
      'usersDone': FieldValue.arrayRemove([authService.getCurrentUserEmail()])
    });
  }

  Stream<List<PhotoChallenge>> readDonePhotoChallenges(
          String currentUserEmail) =>
      _db
          .collection('photoChallenges')
          .where('usersDone', arrayContains: currentUserEmail)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PhotoChallenge.fromJson(doc.data()))
              .toList());
}
