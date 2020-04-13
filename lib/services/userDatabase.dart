import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/user.dart';

class UserDatabaseService {
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  Future addUser(User user) async {
    return await userCollection.add(user.toMap());
  }

  Future<void> updateUser(User user) async {
    return await userCollection.document(user.id).setData(user.toMap());
  }

  Future<User> getUser(String id) async {
    return await userCollection
        .document(id)
        .snapshots()
        .map((snap) => User.fromFirestore(snap))
        .first;
  }

  Future<void> deleteUser(String id) async {
    return await userCollection.document(id).delete();
  }

  Future<List<User>> getAllUsers() async {
    return await userCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => User.fromFirestore(doc)).toList())
        .first;
  }
}
