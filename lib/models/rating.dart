import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String id;
  String userId;
  String portfolioId;
  double stars;

  Rating(this.id, this.userId, this.portfolioId, this.stars);

  factory Rating.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Rating(doc.documentID, data['userId'], data['portfolioId'], data['stars'].toDouble());
  }

  Map<String, dynamic> toMap() {
    return {
      'portfolioId': portfolioId,
      'userId': userId,
      'stars': stars,
    };
  }

  @override
  String toString() {
    return 'Rating{id: $id, userId: $userId, portfolioId: $portfolioId, stars: $stars}';
  }
}
