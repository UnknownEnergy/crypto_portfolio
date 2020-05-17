import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_portfolio/models/coin.dart';

class CoinDatabaseService {
  final CollectionReference coinCollection =
      Firestore.instance.collection('coin');

  Future addCoin(Coin coin) {
    return coinCollection.add(coin.toMap());
  }

  Future<void> updateCoin(Coin coin) {
    return coinCollection.document(coin.id).setData(coin.toMap());
  }

  Future<Coin> getCoin(String id) {
    return coinCollection
        .document(id)
        .snapshots()
        .map((snap) => Coin.fromFirestore(snap))
        .first;
  }

  Future<void> deleteCoin(String id) {
    return coinCollection.document(id).delete();
  }

  Future<List<Coin>> getAllCoins() {
    return coinCollection
        .getDocuments()
        .asStream()
        .map((snap) =>
            snap.documents.map((doc) => Coin.fromFirestore(doc)).toList())
        .first;
  }
}
