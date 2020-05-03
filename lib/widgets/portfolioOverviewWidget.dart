import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/services/portfolioDatabase.dart';
import 'package:crypto_portfolio/widgets/portfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PortfolioOverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none || snap.data == null) {
          return Container();
        }
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Portfolio portfolio = snap.data[index];
            return GestureDetector(
              child: Text("Name: " + portfolio.name),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PortfolioWidget())),
              },
            );
          },
        );
      },
      future: new PortfolioDatabaseService().getAllPortfolios(),
    ));
  }
}
