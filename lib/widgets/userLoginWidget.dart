import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/userDatabase.dart';
import 'package:crypto_portfolio/widgets/homeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              User user = snap.data[index];
              return GestureDetector(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(user.email + " UUID: " + user.id.substring(0,5)+"..."),
                    ]),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeWidget(user))),
                },
              );
            },
          );
        },
        future: new UserDatabaseService().getAllUsers(),
      )),
    );
  }
}
