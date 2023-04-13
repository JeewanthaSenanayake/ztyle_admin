import 'package:flutter/material.dart';
import 'package:ztyle_admin/Navigation.dart';
import 'package:firedart/firedart.dart';

const apiKey = "AIzaSyBwOXWPA8TBeBFHtkJdaRVq_izMWTBrh20";
const projectId = "jbtailors-72459";

void main() {
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
      home: Navigation(DashSelector: 0),
    );
  }
}

// https://youtu.be/Tw7L2NkhwPc
// https://youtu.be/NcuaVjcrhoA