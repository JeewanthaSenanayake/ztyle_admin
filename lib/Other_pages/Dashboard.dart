import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:ztyle_admin/Other_pages/Database/DatabaseManager.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:syncfusion_flutter_charts/charts.dart' as Line_chart;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class SalesDataCgart {
  String catagory;
  int sales;
  SalesDataCgart(this.catagory, this.sales);
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    _tooltipBehavior = Line_chart.TooltipBehavior(enable: true);
    super.initState();
    totalCount();
  }

  bool loading = true;
  String UserCount = "", OderCount = "", SelseCount = "", Revenue = "";
  Map<String, double> dataMap = {};
  dynamic SalesList = [];
  dynamic OrderList = [];
  List<TableRow> TrandingTableRow = [];
  List<Container> TodayOrder = [];

  totalCount() async {
    dynamic Users = await DatabaseManager().getUsers();
    dynamic Oders = await DatabaseManager().Oder();
    dynamic Ratings = await DatabaseManager().TopRatings();
    setState(() {
      UserCount = Users.length.toString();

      int allOdersCount = 0;
      int totalSelesCount = 0;
      double totalRevenue = 0;
      int todayOrderDisplayCount = 0;
      for (var element in Oders) {
        allOdersCount = element["oderID"] + allOdersCount;
        for (int index = 1; index <= element["oderID"]; index++) {
          if (element["$index"]['price'] != 'Pending') {
            totalSelesCount++;
            totalRevenue =
                totalRevenue + double.parse(element["$index"]['price']);
            SalesList.add(element["$index"]);
          }
          OrderList.add(element["$index"]);

          if (todayOrderDisplayCount < 3 &&
              DateFormat('yyyy-MM-dd').format(element["$index"]['date']) ==
                  DateFormat('yyyy-MM-dd').format(DateTime.now())) {
            TodayOrder.add(Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 245, 245),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              transform: Matrix4.rotationX(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInImage(
                    height: scrnheight * 0.0525,
                    placeholder:
                        const AssetImage("assets/LodingImg/loading.jpg"),
                    image: NetworkImage(
                      element["$index"]["oderType"] == "normal"
                          ? element["$index"]["link"]
                          : element["$index"]["basicData"]["url"],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  element["$index"]["oderType"] == "normal"
                      ? Text("${element["$index"]["oderName"]}")
                      : Text("${element["$index"]["basicData"]["ClothType"]}"),
                ],
              ),
            ));
            todayOrderDisplayCount++;
          }
        }
      }
      OderCount = allOdersCount.toString();
      SelseCount = totalSelesCount.toString();
      Revenue = totalRevenue.toStringAsFixed(2);

      makeData();
      makeDataPieChart();
      makeDataLineChart();

      TrandingTableRow.add(const TableRow(children: [
        TableCell(
          child: Text('Product Name',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TableCell(
          child:
              Text('Rate (%)', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]));

      int totalLike = 0;
      for (var element in Ratings) {
        totalLike = element['like'] + totalLike;
      }
      for (int i = 0; i < 3; i++) {
        TrandingTableRow.add(TableRow(children: [
          TableCell(
              child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 15),
            child: Text(Ratings[i]['name']),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
                "${((Ratings[i]['like'] / totalLike) * 100).toStringAsFixed(2)}"),
          )),
        ]));
      }

      loading = false;
    });
  }

  //for line chart
  late Line_chart.TooltipBehavior _tooltipBehavior;
  List<SalesData> LineSalesData = [];
  dynamic LineChartDataMap = {};
  void makeDataLineChart() {
    //-----------------------last week---------------------
    int numDay = 0;
    if (_selectedItemsForOdersLineChart == 'Last Week') {
      numDay = 7;
    } else if (_selectedItemsForOdersLineChart == 'Last 2 Weeks') {
      numDay = 14;
    } else if (_selectedItemsForOdersLineChart == 'Last 3 Weeks') {
      numDay = 21;
    } else if (_selectedItemsForOdersLineChart == 'Last 4 Weeks') {
      numDay = 28;
    }
    DateTime currentDate = DateTime.now();
    DateTime WeekAgo = currentDate.subtract(Duration(days: numDay));
    //-----------------------------------------------------
    setState(() {
      LineChartDataMap = {};
      LineSalesData = [];
      for (var element in OrderList) {
        if ((_selectedItemsForOdersLineChart == 'All Time'
            ? true
            : (element['date']).isAfter(WeekAgo))) {
          if (LineChartDataMap[
                  DateFormat('yyyy-MM-dd').format(element['date'])] ==
              null) {
            LineChartDataMap[DateFormat('yyyy-MM-dd').format(element['date'])] =
                1;
          } else {
            LineChartDataMap[
                DateFormat('yyyy-MM-dd').format(element['date'])]++;
          }
        }
      }

      LineChartDataMap.forEach((key, value) {
        LineSalesData.add(SalesData(key, value.toDouble()));
      });

      LineSalesData.sort((a, b) => DateTime.parse(a.year).compareTo(DateTime.parse(b.year)));
      
    });
  }

  // pie chart
  void makeDataPieChart() {
    double RedymadeCount = 0;
    double CuztormizeCount = 0;
    //-----------------------last week---------------------
    int numDay = 0;
    if (_selectedItemsForOders == 'Last Week') {
      numDay = 7;
    } else if (_selectedItemsForOders == 'Last 2 Weeks') {
      numDay = 14;
    } else if (_selectedItemsForOders == 'Last 3 Weeks') {
      numDay = 21;
    } else if (_selectedItemsForOders == 'Last 4 Weeks') {
      numDay = 28;
    }
    DateTime currentDate = DateTime.now();
    DateTime WeekAgo = currentDate.subtract(Duration(days: numDay));
    //-----------------------------------------------------
    setState(() {
      dataMap = {};
      for (var element in OrderList) {
        if ((_selectedItemsForOders == 'All Time'
            ? true
            : (element['date']).isAfter(WeekAgo))) {
          if (element["oderType"] == "custom") {
            CuztormizeCount++;
          } else if (element["oderType"] == "normal") {
            RedymadeCount++;
          }
        }
      }
      dataMap['Customized'] = CuztormizeCount;
      dataMap['Readymade'] = RedymadeCount;
    });
  }

  //bar chart
  List<SalesDataCgart> _readymade = [];
  List<SalesDataCgart> _custormize = [];
  List<charts.Series<SalesDataCgart, String>> _chartdata = [];
  void makeData() {
    dynamic salesDataForCgart = {
      "readymade": {"men": 0, "women": 0, "kids": 0},
      "custormize": {"men": 0, "women": 0, "kids": 0}
    };
    //-----------------------last week---------------------
    int numDay = 0;
    if (_selectedItem == 'Last Week') {
      numDay = 7;
    } else if (_selectedItem == 'Last 2 Weeks') {
      numDay = 14;
    } else if (_selectedItem == 'Last 3 Weeks') {
      numDay = 21;
    } else if (_selectedItem == 'Last 4 Weeks') {
      numDay = 28;
    }
    DateTime currentDate = DateTime.now();
    DateTime WeekAgo = currentDate.subtract(Duration(days: numDay));
    //-----------------------------------------------------
    setState(() {
      _readymade = [];
      _custormize = [];
      _chartdata = [];
      for (var element in SalesList) {
        if ((_selectedItem == 'All Time'
            ? true
            : (element['date']).isAfter(WeekAgo))) {
          if (element["oderType"] == "normal") {
            if (element["category"] == "men") {
              salesDataForCgart['readymade']['men']++;
            } else if (element["category"] == "women") {
              salesDataForCgart['readymade']['women']++;
            } else if (element["category"] == "kids") {
              salesDataForCgart['readymade']['kids']++;
            }
          } else if (element["oderType"] == "custom") {
            if (element["category"] == "men") {
              salesDataForCgart['custormize']['men']++;
            } else if (element["category"] == "women") {
              salesDataForCgart['custormize']['women']++;
            } else if (element["category"] == "kids") {
              salesDataForCgart['custormize']['kids']++;
            }
          }
        }
      }
//readymade
      _readymade
          .add(SalesDataCgart("Men", salesDataForCgart['readymade']['men']));
      _readymade.add(
          SalesDataCgart("Women", salesDataForCgart['readymade']['women']));
      _readymade
          .add(SalesDataCgart("Kids", salesDataForCgart['readymade']['kids']));
//custormize
      _custormize
          .add(SalesDataCgart("Men", salesDataForCgart['custormize']['men']));
      _custormize.add(
          SalesDataCgart("Women", salesDataForCgart['custormize']['women']));
      _custormize
          .add(SalesDataCgart("Kids", salesDataForCgart['custormize']['kids']));

      _chartdata.add(
        charts.Series(
            id: 'Readymade',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            data: _readymade,
            domainFn: (SalesDataCgart sales, __) => sales.catagory,
            measureFn: (SalesDataCgart sales, __) => sales.sales,
            displayName: 'Readymade'),
      );
      _chartdata.add(
        charts.Series(
            id: 'Custormized',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            data: _custormize,
            domainFn: (SalesDataCgart sales, __) => sales.catagory,
            measureFn: (SalesDataCgart sales, __) => sales.sales,
            displayName: 'Custormized'),
      );
    });
  }

  String _selectedItem = 'All Time';
  String _selectedItemsForOders = 'All Time';
  String _selectedItemsForOdersLineChart = 'All Time';

  List<String> _items = [
    'All Time',
    'Last Week',
    'Last 2 Weeks',
    'Last 3 Weeks',
    'Last 4 Weeks',
  ];

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
          backgroundColor: const Color.fromARGB(255, 115, 118, 121),
        ),
        body: loading
            ? Container(
                alignment: Alignment.center,
                height: scrnheight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.bottomLeft,
                      //   child: Text(
                      //     "Welcom to Admin Dashboard",
                      //     style: TextStyle(
                      //         fontSize: (scrnheight * scrnwidth) * 0.000035),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: (scrnheight * scrnwidth) * 0.00002,
                      // ),
                      Row(children: [
                        Expanded(
                          child: Container(
                              // your first child widget
                              ),
                        ),
                        SizedBox(
                          width: scrnwidth * 0.16,
                          child: Card(
                            color: Color.fromARGB(255, 143, 187, 238),
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '$OderCount\nTotal Orders',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              // your first child widget
                              ),
                        ),
                        SizedBox(
                          width: scrnwidth * 0.16,
                          child: Card(
                            color: Color.fromARGB(255, 240, 143, 211),
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '$SelseCount\nTotal Sales',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              // your first child widget
                              ),
                        ),
                        SizedBox(
                          width: scrnwidth * 0.16,
                          child: Card(
                            color: Color.fromARGB(255, 134, 214, 170),
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '$UserCount\nTotal Customers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              // your first child widget
                              ),
                        ),
                        SizedBox(
                          width: scrnwidth * 0.16,
                          child: Card(
                            color: Color.fromARGB(255, 238, 198, 138),
                            // selectCard == 0 ? Colors.orange : Colors.blue,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Rs.$Revenue\nTotal Revenue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (scrnheight * scrnwidth) * 0.00002),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              // your first child widget
                              ),
                        ),
                      ]),
                      SizedBox(
                        height: (scrnheight * scrnwidth) * 0.00002,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 245, 245),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            transform: Matrix4.rotationX(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Sales",
                                  style: TextStyle(
                                      fontSize:
                                          scrnheight * scrnwidth * 0.000017,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Sales in ",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedItem,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItem = value!;
                                          makeData();
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
                                SizedBox(
                                  height: (scrnheight * scrnwidth) *
                                      0.0002, // specify a fixed height for the charts.BarChart widget
                                  width: (scrnheight * scrnwidth) * 0.000375,
                                  child: charts.BarChart(
                                    _chartdata,
                                    vertical: true,
                                    behaviors: [
                                      charts.SeriesLegend(
                                        position:
                                            charts.BehaviorPosition.bottom,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                // your first child widget
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 245, 245),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            transform: Matrix4.rotationX(0.1),
                            child: SizedBox(
                              height: (scrnheight * scrnwidth) *
                                  0.00025, // specify a fixed height for the charts.BarChart widget
                              width: (scrnheight * scrnwidth) * 0.00027,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Top Rating Readymade Products",
                                      style: TextStyle(
                                          fontSize:
                                              scrnheight * scrnwidth * 0.000017,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Table(
                                    border: const TableBorder(
                                        // verticalInside:
                                        //     BorderSide(width: 1, color: Colors.black),
                                        // horizontalInside: BorderSide(width: 1, color: Colors.black),

                                        ),
                                    columnWidths: {
                                      0: const IntrinsicColumnWidth(),
                                      1: FixedColumnWidth(scrnwidth * 0.045),
                                    },
                                    children: TrandingTableRow,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                // your first child widget
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 245, 245),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            transform: Matrix4.rotationX(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Types",
                                  style: TextStyle(
                                      fontSize:
                                          scrnheight * scrnwidth * 0.000017,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Orders in ",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedItemsForOders,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItemsForOders = value!;

                                          makeDataPieChart();
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
                                Container(
                                  height: (scrnheight * scrnwidth) * 0.0002,
                                  alignment: Alignment.bottomRight,
                                  child: pie_chart.PieChart(
                                    dataMap: dataMap,
                                    animationDuration:
                                        const Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 3.2,
                                    // colorList: colorList,
                                    initialAngleInDegree: 0,
                                    chartType: pie_chart.ChartType.disc,
                                    ringStrokeWidth: 32,

                                    // centerText: "HYBRID",
                                    legendOptions:
                                        const pie_chart.LegendOptions(
                                      showLegendsInRow: false,

                                      legendPosition:
                                          pie_chart.LegendPosition.right,
                                      showLegends: true,
                                      // legendShape: _BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    chartValuesOptions:
                                        const pie_chart.ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: false,
                                      decimalPlaces: 1,
                                    ),

                                    gradientList: const [
                                      [
                                        Colors.red,
                                        Colors.red,
                                      ],
                                      [
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                    ],
                                    // emptyColorGradient: ---Empty Color gradient---
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: (scrnheight * scrnwidth) * 0.00031,
                            width: (scrnheight * scrnwidth) * 0.00057,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 27),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 245, 245),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            transform: Matrix4.rotationX(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Today Orders",
                                    style: TextStyle(
                                        fontSize:
                                            scrnheight * scrnwidth * 0.000017,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: TodayOrder,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                // your first child widget
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 245, 245),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            transform: Matrix4.rotationX(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Growth of Orders",
                                  style: TextStyle(
                                      fontSize:
                                          scrnheight * scrnwidth * 0.000017,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Orders in ",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedItemsForOdersLineChart,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItemsForOdersLineChart =
                                              value!;
                                          makeDataLineChart();
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
                                Container(
                                  height: (scrnheight * scrnwidth) * 0.0002,
                                  width: (scrnheight * scrnwidth) * 0.000525,
                                  alignment: Alignment.bottomRight,
                                  child: Line_chart.SfCartesianChart(
                                      primaryXAxis: Line_chart.CategoryAxis(),
                                      // Chart title
                                      // title: Line_chart.ChartTitle(
                                      //     text: 'Half yearly sales analysis'),
                                      // Enable legend
                                      legend:
                                          Line_chart.Legend(isVisible: false),
                                      // Enable tooltip
                                      tooltipBehavior: _tooltipBehavior,
                                      series: <
                                          Line_chart
                                              .LineSeries<SalesData, String>>[
                                        Line_chart.LineSeries<SalesData,
                                                String>(
                                            dataSource: LineSalesData,
                                            xValueMapper:
                                                (SalesData sales, _) =>
                                                    sales.year,
                                            yValueMapper:
                                                (SalesData sales, _) =>
                                                    sales.sales,
                                            // Enable data label
                                            color: Colors.black,
                                            dataLabelSettings: const Line_chart
                                                    .DataLabelSettings(
                                                isVisible: true))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
