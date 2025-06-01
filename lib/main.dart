import 'dart:io';

import 'package:citpc_connector_app/login_page.dart';
import 'package:flutter/material.dart';

void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CITPC INTERNET",
      theme: ThemeData.dark(),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }

}