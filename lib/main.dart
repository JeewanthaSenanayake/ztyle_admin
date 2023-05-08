import 'package:flutter/material.dart';
import 'package:ztyle_admin/Login.dart';
import 'package:firedart/firedart.dart';

const apiKey = "AIzaSyBwOXWPA8TBeBFHtkJdaRVq_izMWTBrh20";
const projectId = "jbtailors-72459";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.initialize(projectId);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Login(),
    );
  }
}

// Is pending
// 0-delete 
// 1-in customized order customer placed order, tailor may or may not be accepted (tailor accepted can be identified using the price tag) / readymade order in the cart
// 2 – customer paid it means working with order, wrapping with order
// 3 – tailor posted order
// 4 -  received order
// 5 – rejected order

//Loging
//email - ztyle123@gmail.com
//password - ztyle@zaq123