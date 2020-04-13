import 'package:crypto_portfolio/models/user.dart';
import 'package:crypto_portfolio/services/userDatabase.dart';
import 'package:flutter/cupertino.dart';

Widget UserWidget() {
  return FutureBuilder(
    builder: (context, userSnap) {
      if (userSnap.connectionState == ConnectionState.none &&
          userSnap.hasData == null) {
        return Container();
      }
      return ListView.builder(
        itemCount: userSnap.data.length,
        itemBuilder: (context, index) {
          User user = userSnap.data[index];
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("ID: "+user.id),
                  Text("Email: "+user.email),
                  Text("PW: "+user.password),
                ],
              ),
            ],
          );
        },
      );
    },
    future: new UserDatabaseService().getAllUsers(),
  );
}
