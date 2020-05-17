import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/user.dart';

class UserDatabaseService {
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  Future addUser(User user) {
    return userCollection.add(user.toMap());
  }

  Future<void> updateUser(User user) {
    return userCollection.document(user.id).setData(user.toMap());
  }

  Future<User> getUser(String id) {
    return userCollection
        .document(id)
        .snapshots()
        .map((snap) => User.fromFirestore(snap))
        .first;
  }

  Future<void> deleteUser(String id) {
    return userCollection.document(id).delete();
  }

  Future<List<User>> getAllUsers() {
    return userCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => User.fromFirestore(doc)).toList())
        .first;
  }
}
