import 'package:flutter/material.dart';
import 'package:ztyle_admin/Other_pages/Custormers.dart';
import 'package:ztyle_admin/Other_pages/Dashboard.dart';
import 'package:ztyle_admin/Other_pages/Oders.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  dynamic selectedComponent() {
    if (_selectedIndex == 0) {
      return Dashboard();
    } else if (_selectedIndex == 1) {
      return Custormers();
    } else if (_selectedIndex == 2) {
      return Oders();
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: scrnwidth * 0.175,
            // child: NavigationRail(
            //   selectedIndex: _selectedIndex,
            //   onDestinationSelected: (int index) {
            //     setState(() {
            //       _selectedIndex = index;
            //     });
            //   },
            //   labelType: NavigationRailLabelType.all,
            //   backgroundColor: Colors.grey,
            //   destinations: const [
            //     NavigationRailDestination(
            //       icon: Icon(Icons.dashboard_outlined),
            //       selectedIcon: Icon(Icons.dashboard),
            //       label: Text('Dashboard'),
            //     ),
            //     NavigationRailDestination(
            //       icon: Icon(Icons.event_outlined),
            //       selectedIcon: Icon(Icons.event),
            //       label: Text('Oders'),
            //     ),
            //   ],
            // ),
            child: Column(
              children: [
                //hedder
                Container(
                  height: scrnheight * 0.2,
                  padding: EdgeInsets.only(top: scrnheight * 0.05),
                  color: Colors.blue,
                  child: const Text(
                    "Online Taailoring Management System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
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
                      color: _selectedIndex == 0 ? Colors.grey : Colors.white,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(Icons.dashboard_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: Text('Dashboard'),
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
                      color: _selectedIndex == 1 ? Colors.grey : Colors.white,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(Icons.people_outline),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: Text('Customers'),
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
                      color: _selectedIndex == 2 ? Colors.grey : Colors.white,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(Icons.event_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: scrnwidth * 0.005),
                              child: Text('Oders'),
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
            width: 1,
          ),
          Expanded(
            child: selectedComponent(),
          ),
        ],
      ),
    );
  }
}
