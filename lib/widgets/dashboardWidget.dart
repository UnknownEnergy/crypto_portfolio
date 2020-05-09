import 'package:crypto_portfolio/models/coin.dart';
import 'package:crypto_portfolio/models/portfolioCoin.dart';
import 'package:crypto_portfolio/services/coinDatabase.dart';
import 'package:crypto_portfolio/services/portfolioCoinDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildDashboardChart(),
        ]);
  }
}

FutureBuilder<List<dynamic>> buildDashboardChart() {
  return FutureBuilder(
    builder: (context, AsyncSnapshot<List<dynamic>> snap) {
      if (snap.connectionState == ConnectionState.none ||
          snap.data == null ||
          snap.data.length != 2) {
        return Container();
      }
      Map<String, double> dataMap = new Map();
      List<PortfolioCoin> portfolioCoins = snap.data[0]
//          .where((portfolioCoin) => portfolioCoin.portfolioId == portfolioId)
          .toList();

      if (portfolioCoins.length == 0) {
        dataMap.putIfAbsent("None", () => 100);
      } else {
        List<Coin> coins = snap.data[1];
        double totalPercent = portfolioCoins
            .map((portfolioCoin) => portfolioCoin.percent)
            .reduce((sum, element) => sum + element);
        coins.forEach((coin) {
          double coinPercent = 0;

          List<double> percentages = portfolioCoins
              .where((portfolioCoin) => portfolioCoin.coinId == coin.id)
              .map((portfolioCoin) => portfolioCoin.percent).toList();

          if(percentages.length > 0) {
            coinPercent = percentages.reduce((sum, element) => sum + element);
          }

          dataMap.putIfAbsent(
              coin.name, () => coinPercent / totalPercent * 100);
        });
      }
      return PieChart(dataMap: dataMap);
    },
    future: Future.wait([
      new PortfolioCoinDatabaseService().getAllPortfolioCoins(),
      new CoinDatabaseService().getAllCoins()
    ]),
  );
}
