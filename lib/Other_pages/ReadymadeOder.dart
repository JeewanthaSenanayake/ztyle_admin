import 'package:flutter/material.dart';
import 'Database/DatabaseManager.dart';

class RedymadeOder extends StatefulWidget {
  const RedymadeOder({super.key});

  @override
  State<RedymadeOder> createState() => _RedymadeOderState();
}

class _RedymadeOderState extends State<RedymadeOder> {
  @override
  initState() {
    super.initState();
    getRedymadeOder();
  }

  double scrnwidth = 0;
  double scrnheight = 0;
  bool loading = true;
  List<TableRow> OderTable = [];
  getRedymadeOder() async {
    dynamic Redymadedata = await DatabaseManager().Oder();
    dynamic CusData = await DatabaseManager().getUsers();
    String name = "";
    String address = "";
    setState(() {
      for (var element in Redymadedata) {
        for (var element2 in CusData) {
          if (element.id == element2.id) {
            name = element2["name"];
            address = element2["address"];
          }
        }
        for (int index = 0; index < element['oderID']; index++) {
          if (element["${index + 1}"]["isPending"] == 2 &&
              element["${index + 1}"]["oderType"] == "normal") {
            OderTable.add(TableRow(children: [
              TableCell(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: FadeInImage(
                    height: scrnheight * 0.2,
                    placeholder:
                        const AssetImage("assets/LodingImg/loading.jpg"),
                    image: NetworkImage(
                      element["${index + 1}"]["link"],
                    ),
                  ),
                ),
              ),
              TableCell(
                  child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Oder name : ${element["${index + 1}"]["oderName"]}"),
                    Text("Oder colour : ${element["${index + 1}"]["colour"]}"),
                    Text("Oder size : ${element["${index + 1}"]["size"]}"),
                    Text("Price : ${element["${index + 1}"]["price"]}"),
                    Text("Oder size : ${element["${index + 1}"]["size"]}"),
                  ],
                ),
              )),
              TableCell(
                  child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("$name, \n$address")],
                ),
              )),
              TableCell(
                  child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseManager()
                          .SendReadymedeOder(element, index + 1);
                      OderTable = [];
                      loading = true;
                      getRedymadeOder();
                    },
                    child: Text("Send Oder")),
              ))
            ]));
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
      body: SingleChildScrollView(
        child: loading
            ? Container(
                alignment: Alignment.center,
                height: scrnheight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : Container(
                padding: const EdgeInsets.all(15.0),
                width: scrnwidth * 0.7,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Readymade ordes",
                          style: TextStyle(
                              fontSize: scrnwidth * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )),
                    Table(
                      // border: TableBorder.all(),
                      columnWidths: {
                        0: FixedColumnWidth(scrnheight * 0.25),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FixedColumnWidth(scrnheight * 0.2),
                      },
                      children: OderTable,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
