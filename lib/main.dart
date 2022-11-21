import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_store/splash_screen/splash_screen.dart';

import 'page/index_screen.dart';
// SharedPreferences? pre;
void main() async {
    // WidgetsFlutterBinding.ensureInitialized(); // fix lỗi dependency injection - SharedPreferences
  // pre = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Mart',
      theme: ThemeData(

        primarySwatch: Colors.indigo,
      ),
      home: MainPage(),
    );
  }
}


 