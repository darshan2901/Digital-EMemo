import 'package:e_chalan/src/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);
  static const routeName = '/calender';

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Calender"),
      body: const Center(
        child: Text("Yet to impliments"),
      ),
    );
  }
}
