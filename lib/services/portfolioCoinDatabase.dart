import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/portfolioCoin.dart';
import 'package:crypto_portfolio/services/portfolioDatabase.dart';

import 'moderatorDatabase.dart';

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

  Future<List<PortfolioCoin>> getAllPortfolioCoinsOfUser(String userId) async {
    List<PortfolioCoin> portfolioCoins = new List<PortfolioCoin>();

    for (PortfolioCoin portfolioCoin in await getAllPortfolioCoins()) {
      bool isModerator = await new ModeratorDatabaseService()
          .checkIfUserIsModeratorOfPortfolio(userId, portfolioCoin.portfolioId);
      bool isOwner = await new PortfolioDatabaseService()
          .isOwner(portfolioCoin.portfolioId, userId);
      if (isModerator || isOwner) {
        portfolioCoins.add(portfolioCoin);
      }
    }
    return portfolioCoins;
  }
}
