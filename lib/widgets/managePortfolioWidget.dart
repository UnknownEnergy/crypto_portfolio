import 'package:crypto_portfolio/models/coin.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/portfolioCoin.dart';
import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/coinDatabase.dart';
import 'package:crypto_portfolio/services/portfolioCoinDatabase.dart';
import 'package:crypto_portfolio/services/portfolioDatabase.dart';
import 'package:crypto_portfolio/widgets/moderatorWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ManagePortfolioWidget extends StatelessWidget {
  TextEditingController portfolioNameController = new TextEditingController();
  TextEditingController portfolioDescController = new TextEditingController();
  Portfolio currentPortfolio;
  User user;

  ManagePortfolioWidget(Portfolio currentPortfolio, User user) {
    this.currentPortfolio = currentPortfolio;
    this.user = user;

    portfolioNameController.text = currentPortfolio?.name ?? " ";
    portfolioDescController.text = currentPortfolio?.description ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Manage Portfolio'),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  obscureText: false,
                  controller: portfolioNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Portfolio Name',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller: portfolioDescController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Portfolio Description',
                  ),
                ),
                buildCoinList(),
                RaisedButton(
                  onPressed: () {
                    if (currentPortfolio != null) {
                      updateOldPortfolio();
                    } else {
                      createNewPortfolio();
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                RaisedButton(
                  onPressed: () {
                    if (currentPortfolio != null) {
                      new PortfolioDatabaseService()
                          .deletePortfolio(currentPortfolio.id);
                      new PortfolioCoinDatabaseService()
                          .getAllPortfolioCoins()
                          .then((portfolioCoins) {
                        portfolioCoins
                            .where((portfolioCoin) =>
                                portfolioCoin.portfolioId ==
                                currentPortfolio.id)
                            .forEach((portfolioCoin) {
                          new PortfolioCoinDatabaseService()
                              .deletePortfolioCoin(portfolioCoin.id);
                        });
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ModeratorWidget(currentPortfolio, user)),
                    );
                  },
                  child: Text('Manage Moderators'),
                ),
              ])),
    ));
  }

  void updateOldPortfolio() {
    currentPortfolio.name = portfolioNameController.text;
    currentPortfolio.description =
        portfolioDescController.text;
    new PortfolioDatabaseService()
        .updatePortfolio(currentPortfolio);
    new PortfolioCoinDatabaseService()
        .getAllPortfolioCoins()
        .then((portfolioCoins) {
      portfolioCoins
          .where((portfolioCoin) =>
              portfolioCoin.portfolioId ==
              currentPortfolio.id)
          .forEach((portfolioCoin) {
    //                              portfolioCoin.percent = double.parse(percentController.text);
    //                          new PortfolioCoinDatabaseService()
    //                              .updatePortfolioCoin(portfolioCoin);
      });
    });
  }

  void createNewPortfolio() {
    new PortfolioDatabaseService()
        .addPortfolio(new Portfolio(
            "",
            portfolioNameController.text,
            portfolioDescController.text,
            user.id))
        .then((documentReference) {
      new PortfolioCoinDatabaseService().addPortfolioCoin(
          new PortfolioCoin(
              "",
              dropdownKey,
              documentReference.documentID,
              double.parse(percentController.text)));
    });
  }
}

String dropdownValue = 'Bitcoin';
String dropdownKey = '';
TextEditingController percentController = new TextEditingController();

FutureBuilder<List<Coin>> buildCoinList() {
  return FutureBuilder(
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.none || snap.data == null) {
        return DropdownButton(
          items: <DropdownMenuItem>[],
          onChanged: (value) {},
        );
      }
      List<Coin> coins = snap.data;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SearchableDropdown.single(
              items: coins.toList().map<DropdownMenuItem<Coin>>((Coin coin) {
                return DropdownMenuItem<Coin>(
                  value: coin,
                  child: Text(coin.name),
                );
              }).toList(),
              value: dropdownValue,
              hint: "Select one",
              searchHint: "Select one",
              onChanged: (Coin coin) {
                dropdownValue = coin.name;
                dropdownKey = coin.id;
              },
              isExpanded: true,
            ),
            TextField(
                obscureText: false,
                controller: percentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Coin Percent',
                )),
          ]);
    },
    future: new CoinDatabaseService().getAllCoins(),
  );
}
