import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/moderatorRole.dart';

class ModeratorRoleDatabaseService {
  final CollectionReference moderatorRoleCollection =
      Firestore.instance.collection('moderatorRole');

  Future addModeratorRole(ModeratorRole moderatorRole) {
    return moderatorRoleCollection.add(moderatorRole.toMap());
  }

  Future<void> updateModeratorRole(ModeratorRole moderatorRole) {
    return moderatorRoleCollection
        .document(moderatorRole.id)
        .setData(moderatorRole.toMap());
  }

  Future<ModeratorRole> getModeratorRole(String id) {
    return moderatorRoleCollection
        .document(id)
        .snapshots()
        .map((snap) => ModeratorRole.fromFirestore(snap))
        .first;
  }

  Future<void> deleteModeratorRole(String id) {
    return moderatorRoleCollection.document(id).delete();
  }

  Future<List<ModeratorRole>> getAllModeratorRoles() {
    return moderatorRoleCollection
        .getDocuments()
        .asStream()
        .map((snap) => snap.documents
            .map((doc) => ModeratorRole.fromFirestore(doc))
            .toList())
        .first;
  }
}
