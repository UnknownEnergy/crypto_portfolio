import 'package:cloud_firestore/cloud_firestore.dart';

class Coin {
  String id;
  String name;
  String symbol;

  Coin(this.id, this.name, this.symbol);

  factory Coin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Coin(doc.documentID, data['name'], data['symbol']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
    };
  }

  @override
  String toString() {
    return 'Coin{id: $id, name: $name, symbol: $symbol}';
  }
}
