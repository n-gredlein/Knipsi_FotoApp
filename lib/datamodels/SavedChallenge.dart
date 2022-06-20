import 'package:cloud_firestore/cloud_firestore.dart';

class SavedChallenge {
  final String photoChallengeId;

  SavedChallenge({
    required this.photoChallengeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'photoChallengeId': photoChallengeId,
    };
  }

  SavedChallenge.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : photoChallengeId = doc.data()!["photoChallengeId"];
}
