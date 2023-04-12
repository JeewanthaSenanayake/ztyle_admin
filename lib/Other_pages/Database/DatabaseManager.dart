import 'package:firedart/firedart.dart';

class DatabaseManager {
  Future<dynamic> getUsers() async {
    CollectionReference adminInfo =
        Firestore.instance.collection("accountInfo");
    final data = await adminInfo.get();
    return data;
  }

  Future<dynamic> CustormizeOder() async {
    CollectionReference adminInfo = Firestore.instance.collection("Oder");
    final data = await adminInfo.get();
    return data;
  }
}
