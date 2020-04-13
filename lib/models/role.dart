import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  String id;
  String name;

  Role(this.id, this.name);

  factory Role.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Role(doc.documentID, data['name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Role{id: $id, name: $name}';
  }
}
