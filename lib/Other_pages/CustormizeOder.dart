import 'package:flutter/material.dart';
import 'package:ztyle_admin/Navigation.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

class CustormizeOder extends StatefulWidget {
  const CustormizeOder({super.key});

  @override
  State<CustormizeOder> createState() => _CustormizeOderState();
}

class _CustormizeOderState extends State<CustormizeOder> {
  @override
  initState() {
    super.initState();
    getCustomizeOder();
  }

  double scrnwidth = 0;
  double scrnheight = 0;
  List<GestureDetector> CustormizeOderList = [];
  bool loading = true;

  late Widget Displsydetails;

  DisplayDatafun() {
    setState(() {
      Displsydetails = Container(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Navigation(DashSelector: 2)));
          },
          child: Text('click'),
        ),
      );
    });
  }

  bool AfterCkickOder = true;

  getCustomizeOder() async {
    dynamic Custormizedata = await DatabaseManager().CustormizeOder();
    setState(() {
      for (var element in Custormizedata) {
        for (int index = 0; index < element['oderID']; index++) {
          if (element["${index + 1}"]["isPending"] == 1 &&
              element["${index + 1}"]["oderType"] == "custom" &&
              element["${index + 1}"]["price"] == "Pending") {
            CustormizeOderList.add(
              GestureDetector(
                onTap: () {
                  DisplayDatafun();
                  setState(() {
                    AfterCkickOder = false;
                  });
                },
                child: Container(
                  // width: scrnwidth * 0.8,
                  color: Color.fromARGB(96, 98, 243, 134),
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
                        ],
                      )
                    ],
                  ),
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
                      children: CustormizeOderList,
                    ),
                  )
                : Displsydetails,
      ),
    );
  }
}
