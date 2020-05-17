import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/moderator.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/user.dart';

class ModeratorDatabaseService {
  final CollectionReference moderatorCollection =
      Firestore.instance.collection('moderator');

  Future addModerator(Moderator moderator) {
    return moderatorCollection.add(moderator.toMap());
  }

  Future<void> updateModerator(Moderator moderator) {
    return moderatorCollection
        .document(moderator.id)
        .setData(moderator.toMap());
  }

  Future<Moderator> getModerator(String id) {
    return moderatorCollection
        .document(id)
        .snapshots()
        .map((snap) => Moderator.fromFirestore(snap))
        .first;
  }

  Future<void> deleteModerator(String id) {
    return moderatorCollection.document(id).delete();
  }

  Future<List<Moderator>> getAllModerators() {
    return moderatorCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Moderator.fromFirestore(doc)).toList())
        .first;
  }

  Future<bool> checkIfUserIsModeratorOfPortfolio(
      String userId, String portfolioId) {
    return moderatorCollection
        .getDocuments()
        .asStream()
        .map((snap) => snap.documents
            .map((doc) => Moderator.fromFirestore(doc))
            .any((moderator) =>
                moderator.portfolioId == portfolioId &&
                moderator.userId == userId))
        .first;
  }
}
