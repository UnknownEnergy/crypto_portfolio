import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/role.dart';

class RoleDatabaseService {
  final CollectionReference roleCollection =
  Firestore.instance.collection('role');

  Future addRole(Role role) async {
    return await roleCollection.add(role.toMap());
  }

  Future<void> updateRole(Role role) async {
    return await roleCollection.document(role.id).setData(role.toMap());
  }

  Future<Role> getRole(String id) async {
    return await roleCollection
        .document(id)
        .snapshots()
        .map((snap) => Role.fromFirestore(snap))
        .first;
  }

  Future<void> deleteRole(String id) async {
    return await roleCollection.document(id).delete();
  }

  Future<List<Role>> getAllRoles() async {
    return await roleCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Role.fromFirestore(doc)).toList())
        .first;
  }
}
