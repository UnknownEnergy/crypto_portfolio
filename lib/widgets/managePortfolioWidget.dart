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

class ManagePortfolioWidget extends StatefulWidget {
  Portfolio currentPortfolio;
  User user;

  ManagePortfolioWidget(Portfolio currentPortfolio, User user) {
    this.currentPortfolio = currentPortfolio;
    this.user = user;
  }

  @override
  _ManagePortfolioWidgetState createState() {
    return _ManagePortfolioWidgetState(currentPortfolio, user);
  }
}

class _ManagePortfolioWidgetState extends State<ManagePortfolioWidget> {
  TextEditingController portfolioNameController = new TextEditingController();
  TextEditingController portfolioDescController = new TextEditingController();
  Portfolio currentPortfolio;
  User user;
  List<PortfolioCoin> portfolioCoins = new List<PortfolioCoin>();

  _ManagePortfolioWidgetState(Portfolio currentPortfolio, User user) {
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
              body: SingleChildScrollView(
                  child: Column(children: [
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
                createFutureBuilderOfPortfolioCoins(),
                RaisedButton(
                  onPressed: () async {
                    var coins = await new CoinDatabaseService().getAllCoins();
                    Coin defaultCoin =
                        coins.where((coin) => coin.name == 'Bitcoin').first;
                    setState(() {
                      portfolioCoins.add(new PortfolioCoin(
                          '', defaultCoin.id, currentPortfolio.id, 0));
                    });
                  },
                  child: Text('New Coin'),
                ),
                RaisedButton(
                  onPressed: () {
                    onSaveButton(context);
                  },
                  child: Text('Save'),
                ),
                RaisedButton(
                  onPressed: () async {
                    await onDeleteButton(context);
                  },
                  child: Text('Delete'),
                ),
                RaisedButton(
                  onPressed: () {
                    onManageModsButton(context);
                  },
                  child: Text('Manage Moderators'),
                ),
              ])),
            )));
  }

  void onManageModsButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ModeratorWidget(currentPortfolio, user)),
    );
  }

  void onSaveButton(BuildContext context) {
    if (currentPortfolio.id.isNotEmpty) {
      updateOldPortfolio();
    } else {
      createNewPortfolio();
    }
    Navigator.pop(context);
  }

  Future onDeleteButton(BuildContext context) async {
    if (currentPortfolio != null) {
      await new PortfolioDatabaseService().deletePortfolio(currentPortfolio.id);
      await new PortfolioCoinDatabaseService()
          .getAllPortfolioCoins()
          .then((portfolioCoins) {
        portfolioCoins
            .where((portfolioCoin) =>
                portfolioCoin.portfolioId == currentPortfolio.id)
            .forEach((portfolioCoin) {
          new PortfolioCoinDatabaseService()
              .deletePortfolioCoin(portfolioCoin.id);
        });
      });
    }
    Navigator.pop(context);
  }

  Future<void> updateOldPortfolio() async {
    currentPortfolio.name = portfolioNameController.text;
    currentPortfolio.description = portfolioDescController.text;
    await new PortfolioDatabaseService().updatePortfolio(currentPortfolio);
    portfolioCoins.forEach((portfolioCoin) async {
      if (portfolioCoin.id.isEmpty) {
        await new PortfolioCoinDatabaseService()
            .addPortfolioCoin(portfolioCoin);
      } else {
        await new PortfolioCoinDatabaseService()
            .updatePortfolioCoin(portfolioCoin);
      }
    });
  }

  Future<void> createNewPortfolio() async {
    await new PortfolioDatabaseService()
        .addPortfolio(new Portfolio("", portfolioNameController.text,
            portfolioDescController.text, user.id))
        .then((documentReference) async {
      portfolioCoins.forEach((portfolioCoin) async {
        portfolioCoin.portfolioId = documentReference.documentID;
        await new PortfolioCoinDatabaseService()
            .addPortfolioCoin(portfolioCoin);
      });
    });
  }

  FutureBuilder<List<PortfolioCoin>> createFutureBuilderOfPortfolioCoins() {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.none || snap.data == null) {
          return Column();
        }
        List<PortfolioCoin> dbPortfolioCoins = snap.data;
        dbPortfolioCoins.forEach((dbPortfolioCoin) {
          if (!portfolioCoins
              .any((portfolioCoin) => portfolioCoin.id == dbPortfolioCoin.id)) {
            portfolioCoins.add(dbPortfolioCoin);
          }
        });

        List<Column> columns = new List<Column>();
        portfolioCoins.forEach((portfolioCoin) {
          createEachPortfolioColumn(portfolioCoin, columns);
        });

        return Column(children: columns);
      },
      future: new PortfolioCoinDatabaseService()
          .getAllPortfolioCoinsOfPortfolio(currentPortfolio.id),
    );
  }

  Future<void> createEachPortfolioColumn(
      PortfolioCoin portfolioCoin, List<Column> columns) async {
    TextEditingController percentController = new TextEditingController();
    percentController.text = portfolioCoin.percent.toString();

//    var coin = await new CoinDatabaseService().getCoin(portfolioCoin.coinId);

    columns.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //TODO preselect not working?
          createSearchableCoinFutureBuilder('Bitcoin', (Coin coin) {
            portfolioCoin.coinId = coin.id;
          }),
          TextField(
              obscureText: false,
              controller: percentController,
              onChanged: (percent) {
                portfolioCoin.percent = double.parse(percent);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Coin Percent',
              )),
          RaisedButton(
            onPressed: () async {
              await new PortfolioCoinDatabaseService()
                  .deletePortfolioCoin(portfolioCoin.id);
              setState(() {
                portfolioCoins.remove(portfolioCoin);
              });
            },
            child: Text('Remove Coin'),
          ),
        ]));
  }

  FutureBuilder<List<Coin>> createSearchableCoinFutureBuilder(
      String preSelectedValue, Function onCoinChange) {
    return FutureBuilder(
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.none ||
              snap.data == null) {
            return Column();
          }

          List<Coin> coins = snap.data;
          return SearchableDropdown.single(
            items: coins.toList().map<DropdownMenuItem<Coin>>((Coin coin) {
              return DropdownMenuItem<Coin>(
                value: coin,
                child: Text(coin.name),
              );
            }).toList(),
            //TODO preselect not working?
            value: preSelectedValue,
            hint: 'Select one',
            searchHint: 'Select one',
            onChanged: onCoinChange,
            isExpanded: true,
          );
        },
        future: new CoinDatabaseService().getAllCoins());
  }
}
