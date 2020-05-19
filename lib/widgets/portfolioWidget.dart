import 'package:crypto_portfolio/models/coin.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/portfolioCoin.dart';
import 'package:crypto_portfolio/models/rating.dart';
import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/coinDatabase.dart';
import 'package:crypto_portfolio/services/portfolioCoinDatabase.dart';
import 'package:crypto_portfolio/services/ratingDatabase.dart';
import 'package:crypto_portfolio/widgets/managePortfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PortfolioWidget extends StatelessWidget {
  Portfolio portfolio;
  User user;

  PortfolioWidget(Portfolio portfolio, User user) {
    this.portfolio = portfolio;
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Portfolio'),
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      portfolio.name,
                      style: new TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      portfolio.description,
                      style: new TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    buildPortfolioChart(portfolio.id),
                    buildStarRating(user.id, portfolio.id),
                    QrImage(
                      data: portfolio.id,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ManagePortfolioWidget(portfolio, user)));
                },
                child: Icon(Icons.edit),
                backgroundColor: Colors.red,
              ),
            )));
  }

  FutureBuilder<List<dynamic>> buildPortfolioChart(String portfolioId) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<dynamic>> snap) {
        if (snap.connectionState == ConnectionState.none ||
            snap.data == null ||
            snap.data.length != 2) {
          return Container();
        }
        Map<String, double> dataMap = new Map();
        List<PortfolioCoin> portfolioCoins = snap.data[0]
            .where((portfolioCoin) => portfolioCoin.portfolioId == portfolioId)
            .toList();

        if (portfolioCoins.length == 0) {
          dataMap.putIfAbsent("None", () => 100);
        } else {
          portfolioCoins.forEach((portfolioCoin) {
            Coin coin = snap.data[1]
                .where((coin) => coin.id == portfolioCoin.coinId)
                .first;
            dataMap.putIfAbsent(coin.name, () => portfolioCoin.percent);
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
}

FutureBuilder<List<Rating>> buildStarRating(String userId, String portfolioId) {
  return FutureBuilder(
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.none || snap.data == null) {
        return SmoothStarRating();
      }

      double starCounter = 0;
      List<Rating> ratings = snap.data;
      List<double> portfolioRatings = ratings
          .where((rating) => rating.portfolioId == portfolioId)
          .map((rating) => rating.stars)
          .toList();

      if (portfolioRatings.length == 1) {
        starCounter = portfolioRatings.first;
      } else if (portfolioRatings.length == 0) {
        starCounter = 0;
      } else {
        starCounter =
            portfolioRatings.reduce((a, b) => a + b) / portfolioRatings.length;
      }
      return SmoothStarRating(
          allowHalfRating: false,
          starCount: 5,
          rating: starCounter,
          onRatingChanged: (stars) async {
            await new RatingDatabaseService()
                .addRating(new Rating("", userId, portfolioId, stars));
            _showDialog(context, "Voted!",
                "You voted with " + stars.toString() + " stars");
          },
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          spacing: 0.0);
    },
    future: new RatingDatabaseService().getAllRatings(),
  );
}

void _showDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              (context as Element).reassemble();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
