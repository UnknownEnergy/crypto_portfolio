import 'package:cloud_firestore/cloud_firestore.dart';

class Moderator {
  String id;
  String userId;
  String portfolioId;

  Moderator(this.id, this.userId, this.portfolioId);

  factory Moderator.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Moderator(doc.documentID, data['userId'], data['portfolioId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'portfolioId': portfolioId,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'Moderator{id: $id, userId: $userId, portfolioId: $portfolioId}';
  }
}
