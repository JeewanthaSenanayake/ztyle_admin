import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> _textFields = [];
  void OderDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Set require mesherments"),
          children: <Widget>[
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _textFields.add(
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Text Box ${_textFields.length + 1}',
                          ),
                        ),
                      );
                    });
                  },
                  child: Text('Add Text Box'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: _textFields,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      child: const Text("Submit"),
                      onPressed: () async {},
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: const Text("Cancle"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> adminTelNo() async {
    // final adminInfo =
    //     FirebaseFirestore.instance.collection("adminData").doc("telNo");
    CollectionReference adminInfo = Firestore.instance.collection("adminData");
    dynamic AdminDatils;
    try {
      await adminInfo.get().then((QuerySnapshot) {
        AdminDatils = QuerySnapshot.map;
      });

      return AdminDatils;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Column(
        children: [
          Container(
            child: TextButton(
              child: Text("click"),
              onPressed: () async {
                // final data = await adminTelNo();
                // CollectionReference adminInfo =
                //     Firestore.instance.collection("adminData");
                // final data = await adminInfo.get();
                // dynamic data = await DatabaseManager().getUsers();
                // print(data[0].id);
                OderDialogBox();
              },
            ),
          ),
          TextButton(
                  onPressed: () {
                    setState(() {
                      _textFields.add(
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Text Box ${_textFields.length + 1}',
                          ),
                        ),
                      );
                    });
                  },
                  child: Text('Add Text Box'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: _textFields,
                  ),
                ),
        ],
      ),
    );
  }
}
