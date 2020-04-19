import 'package:crypto_portfolio/models/moderator.dart';
import 'package:crypto_portfolio/services/moderatorDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ModeratorWidget() {
  return FutureBuilder(
    builder: (context, userSnap) {
      if (userSnap.connectionState == ConnectionState.none &&
          userSnap.hasData == null) {
        return Container();
      }
      return ListView.builder(
        itemCount: userSnap.data.length,
        itemBuilder: (context, index) {
          Moderator moderator = userSnap.data[index];
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("ID: "+moderator.id),
                  Text("PID: "+moderator.portfolioId),
                  Text("UID: "+moderator.userId),
                ],
              ),
            ],
          );
        },
      );
    },
    future: new ModeratorDatabaseService().getAllModerators(),
  );
}
