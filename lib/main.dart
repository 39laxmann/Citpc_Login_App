import 'dart:io';
import 'package:flutter/material.dart';
import 'package:citpc_connector_app/login_page.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CITPC INTERNET",
      theme: ThemeData.dark(),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
