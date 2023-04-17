import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalCount();
  }

  bool loading = true;
  String UserCount = "", OderCount = "";
  totalCount() async {
    dynamic Users = await DatabaseManager().getUsers();
    dynamic Oders = await DatabaseManager().Oder();
    setState(() {
      UserCount = Users.length.toString();

      int allOdersCount = 0;

      for (var element in Oders) {
        allOdersCount = element["oderID"] + allOdersCount;
      }
      OderCount = allOdersCount.toString();

      loading = false;
    });
  }

  double scrnwidth = 0;
  double scrnheight = 0;
  @override
  Widget build(BuildContext context) {
    setState(() {
      scrnwidth = MediaQuery.of(context).size.width;
      scrnheight = MediaQuery.of(context).size.height;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 115, 118, 121),
      ),
      body: loading
          ? Container(
              alignment: Alignment.center,
              height: scrnheight,
              child: const Center(
                child: CircularProgressIndicator(),
              ))
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Welcom to Admin Dashboard",
                          style: TextStyle(
                              fontSize: (scrnheight * scrnwidth) * 0.000035),
                        ),
                      ),
                      SizedBox(
                        height: (scrnheight * scrnwidth) * 0.00002,
                      ),
                      Row(children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Card(
                            color: Colors.orange,
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '$OderCount\nTotal Orders',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Card(
                            color: Colors.orange,
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '$UserCount\nTotal Customers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
