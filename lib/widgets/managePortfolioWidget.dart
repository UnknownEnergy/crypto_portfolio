import 'package:crypto_portfolio/widgets/moderatorWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagePortfolioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Manage Portfolio'),
              ),
              body: Center(
                  child: DecoratedBox(
                // here is where I added my DecoratedBox
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModeratorWidget()),
                    );
                  },
                  child: Text('Manage Moderators'),
                ),
              )),
            )));
  }
}
