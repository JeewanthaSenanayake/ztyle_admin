import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SalesTable();
  }

  List<TableRow> SalesTableRow = [];
  String _selectedItem = 'All Time';

  List<String> _items = [
    'All Time',
    'Last Week',
    'Last 2 Weeks',
    'Last 3 Weeks',
    'Last 4 Weeks',
  ];
  double scrnwidth = 0;
  double scrnheight = 0;
  int selectCard = 0;
  bool loading = true;
  String oderType = "";

  SalesTable() async {
    dynamic oders = await DatabaseManager().Oder();
    dynamic cuatormuz = await DatabaseManager().getUsers();
    String name = "";
    //-----------------------last week---------------------
    int numDay = 0;
    if (_selectedItem == 'Last Week') {
      numDay = 7;
    } else if (_selectedItem == 'Last 2 Weeks') {
      numDay = 14;
    } else if (_selectedItem == 'Last 3 Weeks') {
      numDay = 21;
    } else if (_selectedItem == 'Last 4 Weeks') {
      numDay = 28;
    }
    DateTime currentDate = DateTime.now();
    DateTime WeekAgo = currentDate.subtract(Duration(days: numDay));
    //-----------------------------------------------------

    //---------------------oder type-------------------
    if (selectCard == 0) {
      oderType = "custom";
    } else if (selectCard == 1) {
      oderType = "normal";
    }
    //-------------------------------------------------
    setState(() {
      SalesTableRow.add(
        TableRow(children: [
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005, right: scrnwidth * 0.005),
            child: const Text('Order ID',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005, right: scrnwidth * 0.005),
            child: const Text('Order Date',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005, right: scrnwidth * 0.005),
            child: const Text('Customer Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005, right: scrnwidth * 0.005),
            child: const Text('Order Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005, right: scrnwidth * 0.005),
            child: const Text('Ammount',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
        ]),
      );
      for (var element in oders) {
        for (var element2 in cuatormuz) {
          if (element.id == element2.id) {
            name = element2["name"];
          }
        }
        for (int index = 1; index <= element['oderID']; index++) {
          if (element['$index']['oderType'] == oderType &&
              element['$index']['price'] != "Pending" &&
              element['$index']['isPending'] != 1 &&
              (_selectedItem == 'All Time'
                  ? true
                  : (element['$index']['date']).isAfter(WeekAgo))) {
            SalesTableRow.add(
              TableRow(children: [
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005, right: scrnwidth * 0.005),
                  child: Text(
                    '$index',
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005, right: scrnwidth * 0.005),
                  child: Text(
                    '${element['$index']['date'].year}-${element['$index']['date'].month}-${element['$index']['date'].day}',
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005, right: scrnwidth * 0.005),
                  child: Text(
                    name,
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005, right: scrnwidth * 0.005),
                  child: selectCard == 0
                      ? Text(
                          element['$index']['basicData']['ClothType'],
                        )
                      : Text("${element['$index']['oderName']}"),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005, right: scrnwidth * 0.005),
                  child: Text(
                    '${element['$index']['price']}',
                  ),
                )),
              ]),
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
          "Sales",
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
            : Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectCard = 0;
                              loading = true;
                              SalesTableRow = [];
                              SalesTable();
                            });
                          },
                          child: Card(
                            color:
                                selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Customized orders',
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
                              SalesTableRow = [];
                              SalesTable();
                            });
                          },
                          child: Card(
                            color:
                                selectCard == 1 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Readymade orders',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: scrnheight * 0.05,
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.all(scrnwidth * 0.01),
                        child: Row(
                          children: [
                            const Text(
                              "Orders in ",
                              style: TextStyle(fontSize: 17),
                            ),
                            DropdownButton<String>(
                              value: _selectedItem,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value!;
                                  loading = true;
                                  SalesTableRow = [];
                                  SalesTable();
                                });
                              },
                              items: _items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(scrnwidth * 0.01),
                      child: Table(
                        //  columnWidths: {
                        // 0: FixedColumnWidth(scrnheight * 0.15),
                        // 1: FixedColumnWidth(scrnheight * 0.175),
                        // 2: IntrinsicColumnWidth(),
                        // 3: FlexColumnWidth(),
                        // 4: FixedColumnWidth(scrnheight * 0.15),

                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: IntrinsicColumnWidth(),
                          3: IntrinsicColumnWidth(),
                          4: IntrinsicColumnWidth(),
                        },
                        // border: TableBorder.all(),
                          border: const TableBorder(
                            verticalInside:
                                BorderSide(width: 1, color: Colors.black),
                            left: BorderSide(width: 1, color: Colors.black),
                            right: BorderSide(width: 1, color: Colors.black),
                          ),
                        children: SalesTableRow,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
