import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ztyle_admin/Navigation.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class CustormizeOder extends StatefulWidget {
  const CustormizeOder({super.key});

  @override
  State<CustormizeOder> createState() => _CustormizeOderState();
}

class _CustormizeOderState extends State<CustormizeOder> {
  int selectCard = 0;
  @override
  initState() {
    super.initState();
    getCustomizeOder();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  double scrnwidth = 0;
  double scrnheight = 0;
  List<GestureDetector> CustormizeOderList = [];
  List<GestureDetector> ReadyToDiliveryOderList = [];
  List<Container> PendingOderList = [];
  bool loading = true;

  dynamic Displsydetails;
  List<String> Meshurments = [];
  String MeshData = '';
  String Price = "";
  bool AfterCkickOder = true;

  List<TableRow> MeshurmentTable = [];
  String remark = "";

  void RejectDialogBox(dynamic element, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Reject Oder"),
          children: <Widget>[
            Container(
                width: scrnwidth * 0.5,
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formkey2,
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Remark",
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Remark Can not be empty';
                            }
                          },
                          onSaved: (text) {
                            remark = text.toString();
                          }),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: const Text("Reject"),
                          onPressed: () async {
                            if (_formkey2.currentState!.validate()) {
                              _formkey2.currentState!.save();
                              await DatabaseManager()
                                  .CustormizeOderReject(element, index, remark);
                              Navigator.of(context).pop();
                              setState(() {
                                CustormizeOderList = [];
                                AfterCkickOder = true;
                                loading = true;
                                getCustomizeOder();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }

  DisplayDatafun(dynamic element, int index) {
    setState(() {
      Displsydetails = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      AfterCkickOder = true;
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            FadeInImage(
              height: scrnheight * 0.5,
              placeholder: const AssetImage("assets/LodingImg/loading.jpg"),
              image: NetworkImage(
                element["$index"]["basicData"]["url"],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element["$index"]["basicData"]["ClothType"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                  ),
                  Text(
                      "Quantity : ${element["$index"]["basicData"]["quantity"]}"),
                  Text("Colour : ${element["$index"]["basicData"]["Colour"]}"),
                  Text("Note : ${element["$index"]["basicData"]["Note"]}"),
                  Text(
                      "Fabric Type : ${element["$index"]["basicData"]["FabricType"]}"),
                  Text(
                      "Time Duration : ${element["$index"]["basicData"]["TimeDuration"]} week"),
                  Text(
                      "Order Date : ${(element["$index"]["date"]).year}-${(element["$index"]["date"]).month}-${(element["$index"]["date"]).day}"),
                  Text(
                      "Contact Number : ${element["$index"]["basicData"]["ContactNumber"]}"),
                ],
              ),
            ),
            // Text("Meshurements ${Meshurments.toString()}"),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    width: scrnwidth * 0.5,
                    child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              "Measurement Names (Seperate Measurements by comma)",
                        ),
                        validator: (text) {
                          if (text.toString().isEmpty) {
                            return 'Measurement Names Can not be empty';
                          }
                        },
                        onSaved: (text) {
                          MeshData = text.toString();
                          Meshurments = MeshData.split(',');
                          Meshurments = Meshurments.map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList();
                          print(Meshurments);

                          print(MeshData);
                          print(Meshurments.length);
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: scrnwidth * 0.25,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price",
                        // hintText: ClothTypeDiscrip,
                      ),
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return 'Price can not be empty';
                        }
                        final doubleNumber = double.tryParse(text!);
                        final intNumber = int.tryParse(text);
                        if (doubleNumber == null && intNumber == null) {
                          return 'Invalide Price';
                        }
                        if (double.parse(text) <= 0) {
                          return 'Price can not be zero or negative';
                        }

                        return null;
                      },
                      onSaved: (text) {
                        Price = text!;
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      await DatabaseManager().CustormizeDataMeshSubmit(
                          element, Meshurments, index, Price);
                      setState(() {
                        CustormizeOderList = [];
                        AfterCkickOder = true;
                        loading = true;
                        getCustomizeOder();
                      });
                    }
                  },
                  child: const Text("Accept"),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: () async {
                    RejectDialogBox(element, index);
                  },
                  child: const Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  CompleateOder(dynamic element, int index) {
    MeshurmentTable = [];
    MeshurmentTable.add(const TableRow(
      children: [
        TableCell(
          child: Text(
            "Measurement",
            style: TextStyle(color: Colors.red),
          ),
        ),
        TableCell(
          child: Text(
            "Value",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
    for (int i = 0; i < (element["$index"]["dataMeasurements"]).length; i++) {
      String key = (element["$index"]["dataMeasurements"])[i].keys.elementAt(0);
      MeshurmentTable.add(TableRow(
        children: [
          TableCell(
            child: Text(key),
          ),
          TableCell(
            child: Text((element["$index"]["dataMeasurements"])[i][key]),
          ),
        ],
      ));
    }
    setState(() {
      Displsydetails = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            FadeInImage(
              height: scrnheight * 0.5,
              placeholder: const AssetImage("assets/LodingImg/loading.jpg"),
              image: NetworkImage(
                element["$index"]["basicData"]["url"],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element["$index"]["basicData"]["ClothType"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                  ),
                  Text(
                      "Quantity : ${element["$index"]["basicData"]["quantity"]}"),
                  Text("Colour : ${element["$index"]["basicData"]["Colour"]}"),
                  Text("Note : ${element["$index"]["basicData"]["Note"]}"),
                  Text(
                      "Fabric Type : ${element["$index"]["basicData"]["FabricType"]}"),
                  Text(
                      "Time Duration : ${element["$index"]["basicData"]["TimeDuration"]} week"),
                  Text(
                      "Order Date : ${(element["$index"]["date"]).year}-${(element["$index"]["date"]).month}-${(element["$index"]["date"]).day}"),
                  Text(
                      "Contact Number : ${element["$index"]["basicData"]["ContactNumber"]}"),
                  Text(
                      "Address : ${element["$index"]["basicData"]["address"]}"),
                  Text("Price : ${element["$index"]["price"]}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // alignment: Alignment.topLeft,
                    width: scrnwidth * 0.35,
                    child: Table(
                      children: MeshurmentTable,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                  onPressed: () async {
                    setState(() {
                      AfterCkickOder = true;
                    });
                  },
                  child: Text("Back"),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () async {
                    await DatabaseManager()
                        .CustormizeOderFinished(element, index);
                    setState(() {
                      ReadyToDiliveryOderList = [];
                      AfterCkickOder = true;
                      loading = true;
                      getCustomizeOder();
                    });
                  },
                  child: Text("Post Oder"),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  getCustomizeOder() async {
    dynamic Custormizedata = await DatabaseManager().Oder();
    setState(() {
      for (var element in Custormizedata) {
        for (int index = 0; index < element['oderID']; index++) {
          if (element["${index + 1}"]["isPending"] == 1 &&
              element["${index + 1}"]["oderType"] == "custom" &&
              element["${index + 1}"]["price"] == "Pending") {
            CustormizeOderList.add(
              GestureDetector(
                onTap: () {
                  DisplayDatafun(element, (index + 1));
                  setState(() {
                    AfterCkickOder = false;
                  });
                },
                child: Container(
                  // width: scrnwidth * 0.8,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 233, 233, 233),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(120, 0, 0, 0),
                        offset: Offset(0, 1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: scrnheight * 0.25,
                        width: scrnheight * 0.275,
                        child: FadeInImage(
                          height: scrnheight * 0.25,
                          placeholder:
                              const AssetImage("assets/LodingImg/loading.jpg"),
                          image: NetworkImage(
                            element["${index + 1}"]["basicData"]["url"],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: scrnwidth * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            element["${index + 1}"]["basicData"]["ClothType"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20),
                          ),
                          Text(
                              "Quantity : ${element["${index + 1}"]["basicData"]["quantity"]}"),
                          Text(
                              "Colour : ${element["${index + 1}"]["basicData"]["Colour"]}"),
                          Text(
                              "Note : ${element["${index + 1}"]["basicData"]["Note"]}"),
                          Text(
                              "Time Duration : ${element["${index + 1}"]["basicData"]["TimeDuration"]} week"),
                          Text(
                              "Order Date : ${(element["${index + 1}"]["date"]).year}-${(element["${index + 1}"]["date"]).month}-${(element["${index + 1}"]["date"]).day}"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (element["${index + 1}"]["isPending"] == 2 &&
              element["${index + 1}"]["oderType"] == "custom") {
            ReadyToDiliveryOderList.add(
              GestureDetector(
                onTap: () {
                  CompleateOder(element, (index + 1));
                  setState(() {
                    AfterCkickOder = false;
                  });
                },
                child: Container(
                  // width: scrnwidth * 0.8,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 233, 233, 233),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(120, 0, 0, 0),
                        offset: Offset(0, 1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: scrnheight * 0.25,
                        width: scrnheight * 0.275,
                        child: FadeInImage(
                          height: scrnheight * 0.25,
                          placeholder:
                              const AssetImage("assets/LodingImg/loading.jpg"),
                          image: NetworkImage(
                            element["${index + 1}"]["basicData"]["url"],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: scrnwidth * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            element["${index + 1}"]["basicData"]["ClothType"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20),
                          ),
                          Text(
                              "Quantity : ${element["${index + 1}"]["basicData"]["quantity"]}"),
                          Text(
                              "Colour : ${element["${index + 1}"]["basicData"]["Colour"]}"),
                          Text(
                              "Note : ${element["${index + 1}"]["basicData"]["Note"]}"),
                          Text(
                              "Time Duration : ${element["${index + 1}"]["basicData"]["TimeDuration"]} week"),
                          Text(
                              "Order Date : ${(element["${index + 1}"]["date"]).year}-${(element["${index + 1}"]["date"]).month}-${(element["${index + 1}"]["date"]).day}"),
                          Text("Price : ${element["${index + 1}"]["price"]}"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (element["${index + 1}"]["isPending"] == 1 &&
              element["${index + 1}"]["oderType"] == "custom" &&
              element["${index + 1}"]["price"] != "Pending") {
            PendingOderList.add(
              Container(
                // width: scrnwidth * 0.8,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      offset: Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      height: scrnheight * 0.25,
                      width: scrnheight * 0.275,
                      child: FadeInImage(
                        height: scrnheight * 0.25,
                        placeholder:
                            const AssetImage("assets/LodingImg/loading.jpg"),
                        image: NetworkImage(
                          element["${index + 1}"]["basicData"]["url"],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: scrnwidth * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element["${index + 1}"]["basicData"]["ClothType"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 20),
                        ),
                        Text(
                            "Quantity : ${element["${index + 1}"]["basicData"]["quantity"]}"),
                        Text(
                            "Colour : ${element["${index + 1}"]["basicData"]["Colour"]}"),
                        Text(
                            "Note : ${element["${index + 1}"]["basicData"]["Note"]}"),
                        Text(
                            "Time Duration : ${element["${index + 1}"]["basicData"]["TimeDuration"]} week"),
                        Text(
                            "Order Date : ${(element["${index + 1}"]["date"]).year}-${(element["${index + 1}"]["date"]).month}-${(element["${index + 1}"]["date"]).day}"),
                        Text("Price : ${element["${index + 1}"]["price"]}"),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
      }
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      scrnwidth = MediaQuery.of(context).size.width;
      scrnheight = MediaQuery.of(context).size.height;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customized orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 115, 118, 121),
      ),
      body: SingleChildScrollView(
        child: loading
            ? Container(
                alignment: Alignment.center,
                height: scrnheight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : AfterCkickOder
                ? Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        // Container(
                        //     padding: const EdgeInsets.only(bottom: 15),
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       "Customized orders",
                        //       style: TextStyle(
                        //           fontSize: scrnwidth * 0.025,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.grey),
                        //     )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectCard = 0;
                                  loading = true;
                                  CustormizeOderList = [];
                                  getCustomizeOder();
                                });
                              },
                              child: Card(
                                color: selectCard == 0
                                    ? Colors.orange
                                    : Colors.blue,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Ready to accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectCard = 1;
                                  loading = true;
                                  ReadyToDiliveryOderList = [];
                                  getCustomizeOder();
                                });
                              },
                              child: Card(
                                color: selectCard == 1
                                    ? Colors.orange
                                    : Colors.blue,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Ready to delivery',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectCard = 2;
                                  loading = true;
                                  PendingOderList = [];
                                  getCustomizeOder();
                                });
                              },
                              child: Card(
                                color: selectCard == 2
                                    ? Colors.orange
                                    : Colors.blue,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Pending order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: scrnheight * 0.05,
                        ),
                        // Text("$selectCard"),
                        selectCard == 0
                            ? Column(
                                children: CustormizeOderList,
                              )
                            : selectCard == 1
                                ? Column(
                                    children: ReadyToDiliveryOderList,
                                  )
                                : Column(
                                    children: PendingOderList,
                                  ),
                      ],
                    ),
                  )
                : Displsydetails,
      ),
    );
  }
}
