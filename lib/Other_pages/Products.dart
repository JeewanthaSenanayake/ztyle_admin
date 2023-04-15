import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  File? file;
  String imageValidator = "";

  String Name = "", fabric_material = "", Price = "";

  String _selectedItem = 'Men';

  List<String> _items = [
    'Men',
    'Women',
    'Kids',
  ];

  getImgInput() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 115, 118, 121),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: scrnwidth * 0.1,
                child: TextButton(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Browse image*',
                          style: TextStyle(
                            fontSize: scrnheight * 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          imageValidator,
                          style: TextStyle(
                            fontSize: scrnwidth * 0.008,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: () async {
                    await getImgInput();
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: file != null
                    ? GestureDetector(
                        onTap: () async {
                          await getImgInput();
                        },
                        child: Image.file(
                          file!,
                          width: scrnwidth * 0.2,
                        ))
                    : Container(
                        child: GestureDetector(
                          onTap: () async {
                            await getImgInput();
                          },
                          child: Image.asset(
                            "assets/LodingImg/lodeImg.jpg",
                            width: scrnwidth * 0.2,
                            // width: 70,
                          ),
                        ),
                      ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: scrnwidth * 0.3,
                margin: EdgeInsets.all(15.0),
                child: Form(
                    key: _formkey1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Type :  "),
                            DropdownButton<String>(
                              value: _selectedItem,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value!;
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
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: 'Name*',
                            labelStyle: TextStyle(
                              fontSize: scrnheight * 0.02,
                              color: Colors.black,
                            ),
                            hintText: "Beautiful cloths",
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Cloth type can not be empty';
                            }
                            return null;
                          },
                          onSaved: (text) {
                            Name = text.toString();
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: 'Fabric material*',
                            labelStyle: TextStyle(
                              fontSize: scrnheight * 0.02,
                              color: Colors.black,
                            ),
                            hintText: "Slik, Cotten",
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Fabric material can not be empty';
                            }
                            return null;
                          },
                          onSaved: (text) {
                            fabric_material = text.toString();
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: 'Price*',
                            labelStyle: TextStyle(
                              fontSize: scrnheight * 0.02,
                              color: Colors.black,
                            ),
                            hintText: "850.25",
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
                      ],
                    )),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (file == null) {
                      setState(() {
                        imageValidator = "Plese select a image";
                      });
                    }
                    if (_formkey1.currentState!.validate() && file != null) {
                      print(_selectedItem);

                    }
                  },
                  child: Text("Add Product"))
            ],
          ),
        ),
      ),
    );
  }
}
