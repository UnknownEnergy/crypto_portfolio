import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/role.dart';

class RoleDatabaseService {
  final CollectionReference roleCollection =
      Firestore.instance.collection('role');

  Future addRole(Role role) {
    return roleCollection.add(role.toMap());
  }

  Future<void> updateRole(Role role) {
    return roleCollection.document(role.id).setData(role.toMap());
  }

  Future<Role> getRole(String id) {
    return roleCollection
        .document(id)
        .snapshots()
        .map((snap) => Role.fromFirestore(snap))
        .first;
  }

  Future<void> deleteRole(String id) {
    return roleCollection.document(id).delete();
  }

  Future<List<Role>> getAllRoles() {
    return roleCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Role.fromFirestore(doc)).toList())
        .first;
  }
}
