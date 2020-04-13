import 'package:cloud_firestore/cloud_firestore.dart';

class ModeratorRole {
  String id;
  String moderatorId;
  String roleId;
  bool confirmed;

  ModeratorRole(this.id, this.moderatorId, this.roleId, this.confirmed);

  factory ModeratorRole.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return ModeratorRole(doc.documentID, data['moderatorId'], data['roleId'], data['confirmed']);
  }

  Map<String, dynamic> toMap() {
    return {
      'moderatorId': moderatorId,
      'roleId': roleId,
      'confirmed': confirmed,
    };
  }

  @override
  String toString() {
    return 'ModeratorRole{id: $id, moderatorId: $moderatorId, roleId: $roleId, confirmed: $confirmed}';
  }
}
