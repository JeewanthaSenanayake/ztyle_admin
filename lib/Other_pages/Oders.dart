import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/CustormizeOder.dart';
import 'package:ztyle_admin/Other_pages/ReadymadeOder.dart';

class Oders extends StatefulWidget {
  const Oders({super.key});

  @override
  State<Oders> createState() => _OdersState();
}

class _OdersState extends State<Oders> {
  int selectCard = 0;
  dynamic SelectedOderType() {
    if (selectCard == 0) {
      return CustormizeOder();
    } else if (selectCard == 1) {
      return RedymadeOder();
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: const Text("Oders")),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectCard = 0;
                    });
                  },
                  child: Card(
                    color: selectCard == 0 ? Colors.orange : Colors.blue,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Customized orders',
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
                    });
                  },
                  child: Card(
                    color: selectCard == 1 ? Colors.orange : Colors.blue,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Readymade ordes',
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
            Expanded(
              child: SelectedOderType(),
            ),
          ],
        ));
  }
}
