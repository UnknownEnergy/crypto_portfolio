import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioCoin {
  String id;
  String coinId;
  String portfolioId;
  double percent;

  PortfolioCoin(this.id, this.coinId, this.portfolioId, this.percent);

  factory PortfolioCoin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return PortfolioCoin(doc.documentID, data['coinId'], data['portfolioId'], data['percent'].toDouble());
  }

  Map<String, dynamic> toMap() {
    return {
      'coinId': coinId,
      'portfolioId': portfolioId,
      'percent': percent,
    };
  }

  @override
  String toString() {
    return 'PortfolioCoin{id: $id, coinId: $coinId, portfolioId: $portfolioId, percent: $percent}';
  }
}
