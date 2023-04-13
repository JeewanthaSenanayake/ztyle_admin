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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double scrnwidth = 0;
  double scrnheight = 0;
  List<GestureDetector> CustormizeOderList = [];
  bool loading = true;

  dynamic Displsydetails;
  List<String> Meshurments = [];
  String MeshData = '';
  String Price = "";

  DisplayDatafun(dynamic element, int index) {
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
                ],
              ),
            ),
            // Text("Meshurements ${Meshurments.toString()}"),
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
                              "Meshurmrnt Name (Seperate Meshurments by comma)",
                        ),
                        validator: (text) {
                          if (text.toString().isEmpty) {
                            return 'Meshurmrnt Name Can not be empty';
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
            Text("${element.id} \n ${index}"),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                }
                print(await DatabaseManager().CustormizeDataMeshSubmit(
                    element, Meshurments, index, Price));
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Navigation(DashSelector: 2)));
              },
              child: const Text('Submit'),
            ),
          ],
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
                  DisplayDatafun(element, (index + 1));
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
