import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/moderatorDatabase.dart';

class PortfolioDatabaseService {
  final CollectionReference portfolioCollection =
      Firestore.instance.collection('portfolio');

  Future addPortfolio(Portfolio portfolio) {
    return portfolioCollection.add(portfolio.toMap());
  }

  Future<void> updatePortfolio(Portfolio portfolio) {
    return portfolioCollection
        .document(portfolio.id)
        .setData(portfolio.toMap());
  }

  Future<Portfolio> getPortfolio(String id) {
    return portfolioCollection
        .document(id)
        .snapshots()
        .map((snap) => Portfolio.fromFirestore(snap))
        .first;
  }

  Future<void> deletePortfolio(String id) {
    return portfolioCollection.document(id).delete();
  }

  Future<List<Portfolio>> getAllPortfolios() {
    return portfolioCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Portfolio.fromFirestore(doc)).toList())
        .first;
  }

  Future<List<Portfolio>> getAllPortfoliosOfUser(User user) async {
    List<Portfolio> portfolios = new List<Portfolio>();

    for (Portfolio portfolio in await getAllPortfolios()) {
      bool isModerator = await new ModeratorDatabaseService()
          .checkIfUserIsModeratorOfPortfolio(user, portfolio);
      if (isModerator || portfolio.ownerUserId == user.id) {
        portfolios.add(portfolio);
      }
    }

    return portfolios;
  }
}
