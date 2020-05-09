import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/rating.dart';
import 'package:crypto_portfolio/services/portfolioDatabase.dart';
import 'package:crypto_portfolio/services/ratingDatabase.dart';
import 'package:crypto_portfolio/widgets/portfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'managePortfolioWidget.dart';

class PortfolioOverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String portfolioId;
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.none ||
              snap.data == null) {
            return Container();
          }
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (context, index) {
              Portfolio portfolio = snap.data[index];
              return GestureDetector(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(portfolio.name),
                      buildStarRating(portfolio),
                    ]),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PortfolioWidget())),
                },
              );
            },
          );
        },
        future: new PortfolioDatabaseService().getAllPortfolios(),
      )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            label: 'New Portolio',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManagePortfolioWidget())),
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blue,
            label: 'Scan QR Code',
            onTap: () async => {
              portfolioId = await scanner.scan(),
            },
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Rating>> buildStarRating(Portfolio portfolio) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none || snap.data == null) {
          return SmoothStarRating();
        }
        double starCounter = 0;
        List<Rating> ratings = snap.data;
        List<int> portfolioRatings = ratings
            .where((rating) => rating.portfolioId == portfolio.id)
            .map((rating) => rating.stars)
            .toList();

        if (portfolioRatings.length == 1) {
          starCounter = portfolioRatings.first.toDouble();
        } else if (portfolioRatings.length == 0) {
          starCounter = 0;
        } else {
          starCounter = portfolioRatings.reduce((a, b) => a + b) /
              portfolioRatings.length;
        }
        return SmoothStarRating(
            allowHalfRating: false,
            starCount: 5,
            rating: starCounter,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            spacing: 0.0);
      },
      future: new RatingDatabaseService().getAllRatings(),
    );
  }
}
