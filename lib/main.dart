import 'package:flutter/material.dart';
import 'package:gallary_app/providerdirectory/Pageprovider.dart';
import 'package:gallary_app/screens/homescreen.dart';
import "package:provider/provider.dart";


void main() {
  runApp(ChangeNotifierProvider(
      create: (_)=>PageProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

