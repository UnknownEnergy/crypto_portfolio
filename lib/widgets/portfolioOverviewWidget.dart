import 'package:crypto_portfolio/models/moderator.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/moderatorDatabase.dart';
import 'package:crypto_portfolio/services/portfolioDatabase.dart';
import 'package:crypto_portfolio/widgets/portfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'managePortfolioWidget.dart';

class PortfolioOverviewWidget extends StatelessWidget {
  User user;

  PortfolioOverviewWidget(User user) {
    this.user = user;
  }

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
                      Text(portfolio.name +
                          getOwnPortfolioText(portfolio, user)),
                      buildStarRating(portfolio.id),
                    ]),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PortfolioWidget(portfolio, user))),
                },
              );
            },
          );
        },
        future: new PortfolioDatabaseService().getAllPortfoliosOfUser(user),
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
                    builder: (context) => ManagePortfolioWidget(null, user))),
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blue,
            label: 'Scan QR Code',
            onTap: () async => {
              onScanQr(user.id, portfolioId, context),
            },
          ),
        ],
      ),
    );
  }
}

Future<void> onScanQr(String userId, String portfolioId, BuildContext context) async {
  String portfolioId = await scanner.scan();
  await new ModeratorDatabaseService()
      .addModerator(new Moderator("", userId, portfolioId));
  (context as Element).reassemble();
}

String getOwnPortfolioText(Portfolio portfolio, User user) {
  if (portfolio.ownerUserId == user.id) {
    return ' - Own Portfolio';
  }
  return '';
}
