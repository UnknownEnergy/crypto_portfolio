import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/portfolio.dart';

class PortfolioDatabaseService {
  final CollectionReference portfolioCollection =
  Firestore.instance.collection('portfolio');

  Future addPortfolio(Portfolio portfolio) async {
    return await portfolioCollection.add(portfolio.toMap());
  }

  Future<void> updatePortfolio(Portfolio portfolio) async {
    return await portfolioCollection.document(portfolio.id).setData(portfolio.toMap());
  }

  Future<Portfolio> getPortfolio(String id) async {
    return await portfolioCollection
        .document(id)
        .snapshots()
        .map((snap) => Portfolio.fromFirestore(snap))
        .first;
  }

  Future<void> deletePortfolio(String id) async {
    return await portfolioCollection.document(id).delete();
  }

  Future<List<Portfolio>> getAllPortfolios() async {
    return await portfolioCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Portfolio.fromFirestore(doc)).toList())
        .first;
  }
}
