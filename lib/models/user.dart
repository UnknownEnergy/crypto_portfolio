import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String password;

  User(this.id, this.email, this.password);

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(doc.documentID, data['email'], data['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'password': this.password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password}';
  }
}
