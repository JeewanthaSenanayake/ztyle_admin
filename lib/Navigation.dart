import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Custormers.dart';
import 'package:ztyle_admin/Other_pages/CustormizeOder.dart';
import 'package:ztyle_admin/Other_pages/Dashboard.dart';

import 'Other_pages/ReadymadeOder.dart';

class Navigation extends StatefulWidget {
  int DashSelector;
  Navigation({super.key, required this.DashSelector});

  @override
  State<Navigation> createState() => _NavigationState(DashSelector);
}

class _NavigationState extends State<Navigation> {
  int DashSelector;
  _NavigationState(this.DashSelector);

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = DashSelector;
  }

  dynamic selectedComponent() {
    if (_selectedIndex == 0) {
      return Dashboard();
    } else if (_selectedIndex == 1) {
      return Custormers();
    } else if (_selectedIndex == 2) {
      return RedymadeOder();
    } else if (_selectedIndex == 3) {
      return CustormizeOder();
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: scrnwidth * 0.175,
            color: Color.fromARGB(100, 204, 207, 209),
            child: Column(
              children: [
                //hedder
                Container(
                  height: scrnheight * 0.3,
                  padding: EdgeInsets.only(top: scrnheight * 0.05),
                  color: Color.fromARGB(255, 115, 118, 121),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icon/icon.png",
                        height: scrnheight * 0.1,
                      ),
                      SizedBox(
                        height: scrnheight * 0.025,
                      ),
                      const Text(
                        "Online Tailoring Management System",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: scrnheight * 0.025,
                ),

                //items
                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 0
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.dashboard_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Dashboard'),
                            ),
                          ],
                        ),
                      )),
                ),

                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 1
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.people_outline),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Customers'),
                            ),
                          ],
                        ),
                      )),
                ),

                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 2
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.card_giftcard_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Readymade orders'),
                            ),
                          ],
                        ),
                      )),
                ),

                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 3
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.event_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Customized orders'),
                            ),
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 6;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 6
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(
                                Icons.production_quantity_limits_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Products'),
                            ),
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 4
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.poll_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Sales'),
                            ),
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    setState(() {
                      _selectedIndex = 5;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(scrnwidth * 0.0075),
                      // margin: EdgeInsets.only(bottom: scrnwidth * 0.005),
                      color: _selectedIndex == 5
                          ? Colors.grey
                          : const Color.fromARGB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.payment_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: const Text('Payment'),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 0,
          ),
          Expanded(
            child: selectedComponent(),
          ),
        ],
      ),
    );
  }
}
