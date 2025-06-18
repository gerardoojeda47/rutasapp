import 'package:flutter/material.dart';
import 'package:rouwhite/view/HomePage.dart';


void main(List<String> args) {
  runApp(Miapp());
}

class Miapp extends StatefulWidget {
  const Miapp({super.key});

  @override
  State<Miapp> createState() => _MiappState();
}

class _MiappState extends State<Miapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Miapp",
      home: Homepage(),
    );
  }
}
