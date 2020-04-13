import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/moderator.dart';

class ModeratorDatabaseService {
  final CollectionReference moderatorCollection =
  Firestore.instance.collection('moderator');

  Future addModerator(Moderator moderator) async {
    return await moderatorCollection.add(moderator.toMap());
  }

  Future<void> updateModerator(Moderator moderator) async {
    return await moderatorCollection.document(moderator.id).setData(moderator.toMap());
  }

  Future<Moderator> getModerator(String id) async {
    return await moderatorCollection
        .document(id)
        .snapshots()
        .map((snap) => Moderator.fromFirestore(snap))
        .first;
  }

  Future<void> deleteModerator(String id) async {
    return await moderatorCollection.document(id).delete();
  }

  Future<List<Moderator>> getAllModerators() async {
    return await moderatorCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Moderator.fromFirestore(doc)).toList())
        .first;
  }
}
