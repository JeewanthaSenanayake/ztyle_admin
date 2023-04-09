import 'package:flutter/material.dart';


class Oders extends StatefulWidget {
  const Oders({super.key});

  @override
  State<Oders> createState() => _OdersState();
}

class _OdersState extends State<Oders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Oders")),
      body: Container(
        child: Text("data 2"),
      ),
    );
  }
}
