import 'dart:typed_data';

import 'package:crypto_portfolio/widgets/managePortfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PortfolioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Portfolio'),
              ),
              body: Center(
                  child: DecoratedBox(
                // here is where I added my DecoratedBox
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: QrImage(
                  data: "12345",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              )),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManagePortfolioWidget()));
                },
                child: Icon(Icons.edit),
                backgroundColor: Colors.red,
              ),
            )));
  }
}
