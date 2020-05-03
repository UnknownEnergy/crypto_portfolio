import 'package:crypto_portfolio/widgets/managePortfolioWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PortfolioWidget extends StatelessWidget {
  Map<String, double> dataMap = new Map();
  double rating = 4;

  @override
  Widget build(BuildContext context) {
    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);

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
                    PieChart(dataMap: dataMap),
                    SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        color: Colors.green,
                        borderColor: Colors.green,
                        spacing:0.0
                    ),
                    QrImage(
                      data: "12345",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ]),
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
