import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 115, 118, 121),
      ),
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
                adminTelNo();
              },
            ),
          ),
        ],
      ),
    );
  }
}
