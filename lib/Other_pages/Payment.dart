import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
                left: scrnwidth * 0.005,
                right: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Order ID',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                right: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Order Date',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                right: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                right: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Amount',
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
                      left: scrnwidth * 0.005,
                      right: scrnwidth * 0.005,
                      top: scrnheight * 0.0175,
                      bottom: scrnheight * 0.0175),
                  child: Text(
                    '$index',
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005,
                      right: scrnwidth * 0.005,
                      top: scrnheight * 0.0175,
                      bottom: scrnheight * 0.0175),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(element['$index']['date']),
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005,
                      right: scrnwidth * 0.005,
                      top: scrnheight * 0.0175,
                      bottom: scrnheight * 0.0175),
                  child: Text(
                    name,
                  ),
                )),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: scrnwidth * 0.005,
                      right: scrnwidth * 0.005,
                      top: scrnheight * 0.0175,
                      bottom: scrnheight * 0.0175),
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

  Future<void> DownloadPDF() async {
    final pdf = pw.Document();

    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Container(
    //         margin: pw.EdgeInsets.all(scrnwidth * 0.01),
    //         child: pw.Text("hi"),
    //       ); // Center
    //     })); // Page

    final headers = ['Name', 'Age', 'Gender'];

    // Define the table data
    final data = [
      ['Alice', '28', 'Female'],
      ['Bob', '35', 'Male'],
      ['Charlie', '42', 'Male'],
      ['David', '19', 'Male'],
      ['Eve', '24', 'Female'],
    ];

    // Create a table widget
    final table = pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(),
      headerDecoration: pw.BoxDecoration(
        // borderRadius: 2,
        color: PdfColors.grey400,
      ),
      // rowDecoration: pw.BoxDecoration(
      //   border: pw.BoxBorder(
      //     bottom: true,
      //     color: PdfColors.grey300,
      //   ),
      // ),
      headerHeight: 30,
      cellHeight: 50,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
      },
    );

    // Add the table to the PDF document
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: table,
        ),
      );
    }));

    final output = await getDownloadsDirectory();
    final file = File("${output!.path}/genpdf.pdf");
    await file.writeAsBytes(await pdf.save());
    print("${output.path}/genpdf.pdf");
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                "Total : Rs.${Total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: ElevatedButton(
                            onPressed: () async {
                              await DownloadPDF();
                            },
                            child: const Text("Generate Report")),
                      ),
                      Container(
                        margin: EdgeInsets.all(scrnwidth * 0.01),
                        child: Table(
                          // border: TableBorder.all(),
                          columnWidths: {
                            0: FixedColumnWidth(scrnheight * 0.35),
                            1: FixedColumnWidth(scrnheight * 0.375),
                            3: FixedColumnWidth(scrnheight * 0.375),
                          },
                          border: const TableBorder(
                            horizontalInside:
                                BorderSide(width: 1, color: Colors.grey),
                            bottom: BorderSide(width: 1, color: Colors.grey),
                          ),
                          children: PaymentTableRow,
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}
