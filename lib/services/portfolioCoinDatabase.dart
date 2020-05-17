import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/portfolioCoin.dart';

class PortfolioCoinDatabaseService {
  final CollectionReference portfolioCoinCollection =
      Firestore.instance.collection('portfolioCoin');

  Future addPortfolioCoin(PortfolioCoin portfolioCoin) {
    return portfolioCoinCollection.add(portfolioCoin.toMap());
  }

  Future<void> updatePortfolioCoin(PortfolioCoin portfolioCoin) {
    return portfolioCoinCollection
        .document(portfolioCoin.id)
        .setData(portfolioCoin.toMap());
  }

  Future<PortfolioCoin> getPortfolioCoin(String id) {
    return portfolioCoinCollection
        .document(id)
        .snapshots()
        .map((snap) => PortfolioCoin.fromFirestore(snap))
        .first;
  }

  Future<void> deletePortfolioCoin(String id) {
    return portfolioCoinCollection.document(id).delete();
  }

  Future<List<PortfolioCoin>> getAllPortfolioCoins() {
    return portfolioCoinCollection
        .getDocuments()
        .asStream()
        .map((snap) => snap.documents
            .map((doc) => PortfolioCoin.fromFirestore(doc))
            .toList())
        .first;
  }
}
