import 'package:cloud_firestore/cloud_firestore.dart';

class ModeratorRole {
  String id;
  String moderatorId;
  String roleId;

  ModeratorRole(this.id, this.moderatorId, this.roleId);

  factory ModeratorRole.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return ModeratorRole(doc.documentID, data['moderatorId'], data['roleId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'moderatorId': moderatorId,
      'roleId': roleId,
    };
  }

  @override
  String toString() {
    return 'ModeratorRole{id: $id, moderatorId: $moderatorId, roleId: $roleId}';
  }
}
