import 'package:firedart/firedart.dart';

class DatabaseManager {
  //read database
  Future<dynamic> getUsers() async {
    CollectionReference adminInfo =
        Firestore.instance.collection("accountInfo");
    final data = await adminInfo.get();
    return data;
  }

  Future<dynamic> Oder() async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    final data = await OderInfoInfo.get();
    return data;
  }

  Future<dynamic> MenProducts() async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("men");
    final data = await OderInfoInfo.get();
    return data;
  }

  Future<dynamic> WemenProducts() async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("women");
    final data = await OderInfoInfo.get();
    return data;
  }

  Future<dynamic> KidsProducts() async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("kids");
    final data = await OderInfoInfo.get();
    return data;
  }

//write database

  Future<dynamic> CustormizeDataMeshSubmit(dynamic oderData,
      List<String> Meshurments, int oderID, String Price) async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    //create new map
    Map<String, dynamic> data = {};
    for (int i = 1; i <= oderData["oderID"]; i++) {
      data[i.toString()] = oderData[i.toString()];
    }
    data["oderID"] = oderData["oderID"];
    data["$oderID"]["Measurements"] = Meshurments;
    data["$oderID"]["price"] = Price;
    
    return await OderInfoInfo.document(oderData.id).set(data);
  }

  Future<dynamic> CustormizeOderFinished(
    dynamic oderData,
    int oderID,
  ) async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    //create new map
    Map<String, dynamic> data = {};
    for (int i = 1; i <= oderData["oderID"]; i++) {
      data[i.toString()] = oderData[i.toString()];
    }
    data["oderID"] = oderData["oderID"];
    data["$oderID"]["isPending"] = 3;
    data["$oderID"]["status"] = "Oder Posted";
  
    return await OderInfoInfo.document(oderData.id).set(data);
  }

  Future<dynamic> SendReadymedeOder(
    dynamic oderData,
    int oderID,
  ) async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    //create new map
    Map<String, dynamic> data = {};
    for (int i = 1; i <= oderData["oderID"]; i++) {
      data[i.toString()] = oderData[i.toString()];
    }
    data["oderID"] = oderData["oderID"];
    data["$oderID"]["isPending"] = 3;
    data["$oderID"]["status"] = "Oder Posted";

    return await OderInfoInfo.document(oderData.id).set(data);
  }

  Future<dynamic> CustormizeOderReject(
      dynamic oderData, int oderID, String Remark) async {
    CollectionReference OderInfoInfo = Firestore.instance.collection("Oder");
    //create new map
    Map<String, dynamic> data = {};
    for (int i = 1; i <= oderData["oderID"]; i++) {
      data[i.toString()] = oderData[i.toString()];
    }
    data["oderID"] = oderData["oderID"];
    data["$oderID"]["isPending"] = 5; //5 for reject
    data["$oderID"]["status"] = "Rejected";
    data["$oderID"]["remark"] = Remark;
  
    return await OderInfoInfo.document(oderData.id).set(data);
  }

  Future<dynamic> EditProducts(
      dynamic data, String name, String price, String colection) async {
    CollectionReference Products = Firestore.instance.collection(colection);

    dynamic UpdatedProductData = data.map;

    UpdatedProductData['name'] = name;
    UpdatedProductData["price"] = price;

    return await Products.document(data.id).set(UpdatedProductData);
  }

  Future<dynamic> DeleteProducts(dynamic data, String colection) async {
    CollectionReference Products = Firestore.instance.collection(colection);

    return await Products.document(data.id).delete();
  }

  Future<dynamic> AddProducts(dynamic data, String colection) async {
    CollectionReference Products = Firestore.instance.collection(colection);
    DocumentReference imgID = Firestore.instance
        .collection("adminData")
        .document("readymadeOrdersId");
    final count = await imgID.get();
    int newId = count["oderId"] + 1;
    data["imgId"] = "${colection}_$newId";
    await imgID.update({"oderId": newId});

    return await Products.document("${colection}_$newId").set(data);
  }
}
