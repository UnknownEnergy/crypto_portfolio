import 'package:cloud_firestore/cloud_firestore.dart';

class Portfolio {
  String id;
  String name;
  String description;
  String ownerUserId;

  Portfolio(this.id, this.name, this.description, this.ownerUserId);

  factory Portfolio.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Portfolio(doc.documentID, data['name'], data['description'], data['owner']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'owner': ownerUserId,
    };
  }

  @override
  String toString() {
    return 'Portfolio{id: $id, name: $name, description: $description, ownerUserId: $ownerUserId}';
  }

  @override
  bool operator ==(Object other) =>
      other is Portfolio &&
          name == other.name &&
          description == other.description &&
          ownerUserId == other.ownerUserId;

  @override
  int get hashCode =>
      name.hashCode ^ description.hashCode ^ ownerUserId.hashCode;
}
