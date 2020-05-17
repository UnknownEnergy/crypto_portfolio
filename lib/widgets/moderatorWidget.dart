import 'package:crypto_portfolio/models/moderator.dart';
import 'package:crypto_portfolio/models/portfolio.dart';
import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/moderatorDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModeratorWidget extends StatelessWidget {
  Portfolio currentPortfolio;
  User user;

  ModeratorWidget(Portfolio currentPortfolio, User user) {
    this.currentPortfolio = currentPortfolio;
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Manage Moderators'),
                ),
                body: FutureBuilder(
                  builder: (context, userSnap) {
                    if (userSnap.connectionState == ConnectionState.none ||
                        userSnap.data == null) {
                      return Container();
                    }
                    return ListView.builder(
                        itemCount: 1,
                        padding: const EdgeInsets.all(15.0),
                        itemBuilder: (context, position) {
                          Moderator moderator = userSnap.data[position];
                          return Column(
                            children: <Widget>[
                              TextField(
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Moderator',
                                ),
                              ),
                              Divider(height: 5.0),
                              ListTile(
                                title: Text(
                                  "ID: " + moderator.userId,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),

                                trailing: Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.all(5.0)),
                                    GestureDetector(
                                        onTap: () {}, child: Icon(Icons.delete))
                                  ],
                                ),
                                // onTap: () => _navigateToNote(context, items[position]),
                              ),
                            ],
                          );
                        });
                  },
                  future: new ModeratorDatabaseService().getAllModerators(),
                ))));
  }
}
