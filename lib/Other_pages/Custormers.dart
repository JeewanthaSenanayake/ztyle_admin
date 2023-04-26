import 'package:flutter/material.dart';
import 'Database/DatabaseManager.dart';

class Custormers extends StatefulWidget {
  const Custormers({super.key});
  @override
  State<Custormers> createState() => _CustormersState();
}

class _CustormersState extends State<Custormers> {
  @override
  initState() {
    super.initState();
    getCustomers();
  }

  double scrnwidth = 0;
  double scrnheight = 0;
  List<TableRow> CustomerTable = [];
  bool loading = true;

  getCustomers() async {
    dynamic CusData = await DatabaseManager().getUsers();
    setState(() {
      CustomerTable.add(
        TableRow(children: [
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('E-mail',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: EdgeInsets.only(
                left: scrnwidth * 0.005,
                top: scrnheight * 0.0175,
                bottom: scrnheight * 0.0175),
            child: const Text('Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
        ]),
      );
      for (var element in CusData) {
        CustomerTable.add(
          TableRow(children: [
            TableCell(
                child: Padding(
              padding: EdgeInsets.only(
                  left: scrnwidth * 0.005,
                  top: scrnheight * 0.0175,
                  bottom: scrnheight * 0.0175),
              child: Text(element['name']),
            )),
            TableCell(
                child: Padding(
              padding: EdgeInsets.only(
                  left: scrnwidth * 0.005,
                  top: scrnheight * 0.0175,
                  bottom: scrnheight * 0.0175),
              child: Text(element['email']),
            )),
            TableCell(
                child: Padding(
              padding: EdgeInsets.only(
                  left: scrnwidth * 0.005,
                  top: scrnheight * 0.0175,
                  bottom: scrnheight * 0.0175),
              child: Text(element['address']),
            )),
          ]),
        );
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
            "Customers",
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
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(scrnwidth * 0.01),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside:
                              BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                        ),
                        // border: TableBorder.all(),
                        children: CustomerTable,
                      ),
                    )
                  ],
                ),
        ));
  }
}
