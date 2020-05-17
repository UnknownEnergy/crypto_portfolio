import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/rating.dart';

class RatingDatabaseService {
  final CollectionReference ratingCollection =
      Firestore.instance.collection('rating');

  Future addRating(Rating rating) {
    return ratingCollection.add(rating.toMap());
  }

  Future<void> updateRating(Rating rating) {
    return ratingCollection.document(rating.id).setData(rating.toMap());
  }

  Future<Rating> getRating(String id) {
    return ratingCollection
        .document(id)
        .snapshots()
        .map((snap) => Rating.fromFirestore(snap))
        .first;
  }

  Future<void> deleteRating(String id) {
    return ratingCollection.document(id).delete();
  }

  Future<List<Rating>> getAllRatings() {
    return ratingCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Rating.fromFirestore(doc)).toList())
        .first;
  }
}
