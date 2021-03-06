import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/widgets/dashboardWidget.dart';
import 'package:crypto_portfolio/widgets/portfolioOverviewWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  User user;

  HomeWidget(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'Portfolio'),
              ],
            ),
            title: Text('Crypto Portfolio Manager'),
          ),
          body: TabBarView(
            children: [
              DashboardWidget(user),
              PortfolioOverviewWidget(user),
            ],
          ),
        ),
      ),
    );
  }
}
