import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference coinCollection =
      Firestore.instance.collection('coin');
  final CollectionReference userCollection =
      Firestore.instance.collection('user');
  final CollectionReference roleCollection =
      Firestore.instance.collection('role');
  final CollectionReference moderatorCollection =
      Firestore.instance.collection('moderator');
  final CollectionReference moderatorRoleCollection =
      Firestore.instance.collection('moderatorRole');
  final CollectionReference portfolio =
      Firestore.instance.collection('portfolio');
  final CollectionReference portfolioCoin =
      Firestore.instance.collection('portfolioCoin');

  Future addCoin(String name, String symbole) async {
    return await coinCollection.add({
      'name': name,
      'symbol': symbole,
    });
  }

  Future updateCoin(String id, String name, String symbole) async {
    return await coinCollection.document(id).setData({
      'name': name,
      'symbol': symbole,
    });
  }

  Future addModerator(String userId, String portfolioId) async {
    return await coinCollection.add({
      'portfolioId': portfolioId,
      'userId': userId,
    });
  }

  Future updateModerator(String id, String userId, String portfolioId) async {
    return await coinCollection.document(id).setData({
      'portfolioId': portfolioId,
      'userId': userId,
    });
  }

  Future addModeratorRole(String moderatorId, String roleId) async {
    return await coinCollection.add({
      'moderatorId': moderatorId,
      'roleId': roleId,
    });
  }

  Future updateModeratorRole(
      String id, String moderatorId, String roleId) async {
    return await coinCollection.document(id).setData({
      'moderatorId': moderatorId,
      'roleId': roleId,
    });
  }

  Future addPortfolio(
      String name, String description, String ownerUserId) async {
    return await coinCollection.add({
      'name': name,
      'description': description,
      'owner': ownerUserId,
    });
  }

  Future updatePortfolio(
      String id, String name, String description, String ownerUserId) async {
    return await coinCollection.document(id).setData({
      'name': name,
      'description': description,
      'owner': ownerUserId,
    });
  }

  Future addPortfolioCoin(
      String coinId, String portfolioId, double percent) async {
    return await coinCollection.add({
      'coinId': coinId,
      'portfolioId': portfolioId,
      'percent': percent,
    });
  }

  Future updatePortfolioCoin(
      String id, String coinId, String portfolioId, double percent) async {
    return await coinCollection.document(id).setData({
      'coinId': coinId,
      'portfolioId': portfolioId,
      'percent': percent,
    });
  }

  Future addRole(String name) async {
    return await coinCollection.add({
      'name': name,
    });
  }

  Future updateRole(String id, String name) async {
    return await coinCollection.document(id).setData({
      'name': name,
    });
  }

  Future addUser(String email, String password) async {
    return await coinCollection.add({
      'email': email,
      'password': password,
    });
  }

  Future updateUser(String id, String email, String password) async {
    return await coinCollection.document(id).setData({
      'email': email,
      'password': password,
    });
  }
}
