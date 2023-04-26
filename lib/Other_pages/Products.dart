import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';

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

  double scrnwidth = 0;
  double scrnheight = 0;
  int selectCard = 0;
  bool loading = true;
  bool displayProduct = true;
  List<Container> Products = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DisplayProduct();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  void EditProductDialog(dynamic data) {
    String name = "";
    String price = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Edit Products Details'),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: TextEditingController(text: data['name']),
                          decoration: const InputDecoration(
                            labelText: "Name",
                          ),
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return 'Name can not be empty';
                            }
                            return null;
                          },
                          onSaved: (text) {
                            name = text.toString();
                          }),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller:
                              TextEditingController(text: data['price']),
                          decoration: const InputDecoration(
                            labelText: "Price",
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
                            price = text.toString();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                            child: const Text('Cancle'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue)),
                            child: const Text('Update'),
                            onPressed: () async {
                              _formkey.currentState!.save();
                              if (_formkey.currentState!.validate()) {
                                await DatabaseManager().EditProducts(
                                    data,
                                    name,
                                    price,
                                    (selectCard == 0
                                        ? "men"
                                        : selectCard == 1
                                            ? "women"
                                            : selectCard == 2
                                                ? "kids"
                                                : ""));

                                Navigator.of(context).pop();
                                loading = true;
                                Products = [];
                                DisplayProduct();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
            )
          ],
        );
      },
    );
  }

  void DeleteProductDialog(dynamic data) {
    String name = "";
    String price = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Delete ${data['name']} ?'),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    child: const Text('Cancle'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    child: const Text('Delete'),
                    onPressed: () async {
                      await DatabaseManager().DeleteProducts(
                          data,
                          (selectCard == 0
                              ? "men"
                              : selectCard == 1
                                  ? "women"
                                  : selectCard == 2
                                      ? "kids"
                                      : ""));

                      Navigator.of(context).pop();
                      loading = true;
                      Products = [];
                      DisplayProduct();
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  DisplayProduct() async {
    dynamic data;

    if (selectCard == 0) {
      data = await DatabaseManager().MenProducts();
    } else if (selectCard == 1) {
      data = await DatabaseManager().WemenProducts();
    } else if (selectCard == 2) {
      data = await DatabaseManager().KidsProducts();
    }
    setState(() {
      for (var element in data) {
        Products.add(
          Container(
            // width: scrnwidth * 0.8,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 233, 233, 233),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(120, 0, 0, 0),
                  offset: Offset(0, 1),
                  blurRadius: 5,
                ),
              ],
            ),
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
                      element["url"],
                    ),
                  ),
                ),
                SizedBox(
                  width: scrnwidth * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Text("Fabric Material : ${element["fabric_material"]}"),
                    Text("Likes : ${element["like"]}"),
                    Text("Dislike : ${element["disLike"]}"),
                    Text("Price : Rs.${element["price"]}"),
                  ],
                ),
                const Spacer(),
                Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue)),
                          onPressed: () {
                            EditProductDialog(element);
                          },
                          child: const Text("Edit"),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () {
                            DeleteProductDialog(element);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    )),
              ],
            ),
          ),
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
          "Products",
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
                margin: EdgeInsets.all(15.0),
                child: displayProduct
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectCard = 0;
                                    loading = true;
                                    Products = [];
                                    DisplayProduct();
                                  });
                                },
                                child: Card(
                                  color: selectCard == 0
                                      ? Colors.orange
                                      : Colors.blue,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Men',
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
                                    Products = [];
                                    DisplayProduct();
                                  });
                                },
                                child: Card(
                                  color: selectCard == 1
                                      ? Colors.orange
                                      : Colors.blue,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Women',
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
                                    selectCard = 2;
                                    loading = true;
                                    Products = [];
                                    DisplayProduct();
                                  });
                                },
                                child: Card(
                                  color: selectCard == 2
                                      ? Colors.orange
                                      : Colors.blue,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Kids',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: scrnheight * 0.05,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: scrnwidth * 0.11,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      displayProduct = false;
                                    });
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.add),
                                      Text("Add Product"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //for add product and display products
                          Column(
                            children: Products,
                          )
                        ],
                      )
                    : Column(
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
                                        // hintText: "Beautiful cloths",
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
                                        hintText: "Viscose, Cotton, Mazza",
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
                                        // hintText: "850.25",
                                      ),
                                      validator: (text) {
                                        if (text.toString().isEmpty) {
                                          return 'Price can not be empty';
                                        }
                                        final doubleNumber =
                                            double.tryParse(text!);
                                        final intNumber = int.tryParse(text);
                                        if (doubleNumber == null &&
                                            intNumber == null) {
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
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                displayProduct = true;
                                                imageValidator = "";
                                                file = null;
                                              });
                                            },
                                            child: const Text("Back")),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              if (file == null) {
                                                setState(() {
                                                  imageValidator =
                                                      "Please select a image";
                                                });
                                              }
                                              if (_formkey1.currentState!
                                                      .validate() &&
                                                  file != null) {
                                                _formkey1.currentState!.save();
                                                print(_selectedItem);
                                                Map<String, dynamic>
                                                    ProdectDataMap = {
                                                  "customer": {},
                                                  "disLike": 0,
                                                  "fabric_material":
                                                      fabric_material,
                                                  "like": 0,
                                                  "name": Name,
                                                  "price": Price,
                                                  "type": _selectedItem.toLowerCase(),
                                                  "url":
                                                      "https://firebasestorage.googleapis.com/v0/b/jbtailors-72459.appspot.com/o/men%2Fphoto_2023-04-26_22-30-00.jpg?alt=media&token=31b13aa1-1f46-493e-89bd-7ccb4867c5b9",
                                                };
                                                DatabaseManager().AddProducts(
                                                    ProdectDataMap,
                                                    _selectedItem
                                                        .toLowerCase());
                                                setState(() {
                                                  loading = true;

                                                  imageValidator = "";
                                                  file = null;
                                                  DisplayProduct();
                                                  displayProduct = true;
                                                });
                                              }
                                            },
                                            child: const Text("Add Product"))
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )),
      ),
    );
  }
}
