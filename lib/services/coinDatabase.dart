import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/coin.dart';

class CoinDatabaseService {
  final CollectionReference coinCollection =
  Firestore.instance.collection('coin');

  Future addCoin(Coin coin) async {
    return await coinCollection.add(coin.toMap());
  }

  Future<void> updateCoin(Coin coin) async {
    return await coinCollection.document(coin.id).setData(coin.toMap());
  }

  Future<Coin> getCoin(String id) async {
    return await coinCollection
        .document(id)
        .snapshots()
        .map((snap) => Coin.fromFirestore(snap))
        .first;
  }

  Future<void> deleteCoin(String id) async {
    return await coinCollection.document(id).delete();
  }

  Future<List<Coin>> getAllCoins() async {
    return await coinCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Coin.fromFirestore(doc)).toList())
        .first;
  }
}
