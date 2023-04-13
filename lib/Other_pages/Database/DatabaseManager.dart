import 'package:firedart/firedart.dart';

class DatabaseManager {
  Future<dynamic> getUsers() async {
    CollectionReference adminInfo =
        Firestore.instance.collection("accountInfo");
    final data = await adminInfo.get();
    return data;
  }

  Future<dynamic> CustormizeOder() async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    final data = await OderInfoInfo.get();
    return data;
  }

  Future<dynamic> CustormizeDataMeshSubmit(dynamic oderData,
      List<String> Meshurments, int oderID, String Price) async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");

    Map<String, dynamic> data = {};
    for (int i = 1; i <= oderData["oderID"]; i++) {
      data[i.toString()] = oderData[i.toString()];
    }
    data["oderID"] = oderData["oderID"];
    data["$oderID"]["Measurements"] = Meshurments;
    data["$oderID"]["price"] = Price;
    print(data);
    return await OderInfoInfo.document(oderData.id).set(data);
  }
}
