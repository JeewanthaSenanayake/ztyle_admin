import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PaymentTable();
  }

  double scrnwidth = 0;
  double scrnheight = 0;
  List<TableRow> PaymentTableRow = [];
  bool loading = true;
  double Total = 0;

  String _selectedItem = 'All Time';

  List<String> _items = [
    'All Time',
    'Last Week',
    'Last 2 Weeks',
    'Last 3 Weeks',
    'Last 4 Weeks',
  ];

  PaymentTable() async {
    dynamic oders = await DatabaseManager().Oder();
    dynamic cuatormuz = await DatabaseManager().getUsers();
    String name = "";
    Total = 0;
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
    setState(() {
      PaymentTableRow.add(
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
            child: const Text('Name',
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
          if (element['$index']['price'] != "Pending" &&
              element['$index']['isPending'] != 1 &&
              (_selectedItem == 'All Time'
                  ? true
                  : (element['$index']['date']).isAfter(WeekAgo))) {
            Total = Total + double.parse(element['$index']['price']);
            PaymentTableRow.add(
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
          "Payment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 115, 118, 121),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(15.0),
            child: loading
                ? Container(
                    alignment: Alignment.center,
                    height: scrnheight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ))
                : Column(
                    children: [
                      Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.all(scrnwidth * 0.01),
                          child: Row(
                            children: [
                              const Text(
                                "Payments in ",
                                style: TextStyle(fontSize: 17),
                              ),
                              DropdownButton<String>(
                                value: _selectedItem,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedItem = value!;
                                    loading = true;
                                    PaymentTableRow = [];
                                    PaymentTable();
                                  });
                                },
                                items: _items.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                              const Spacer(),
                              Text(
                                "Total : Rs.$Total",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(scrnwidth * 0.01),
                        child: Table(
                          // border: TableBorder.all(),
                          border: const TableBorder(
                            verticalInside:
                                BorderSide(width: 1, color: Colors.black),
                            left: BorderSide(width: 1, color: Colors.black),
                            right: BorderSide(width: 1, color: Colors.black),
                          ),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: IntrinsicColumnWidth(),
                            2: IntrinsicColumnWidth(),
                            3: IntrinsicColumnWidth(),
                            4: IntrinsicColumnWidth(),
                          },
                          children: PaymentTableRow,
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}
