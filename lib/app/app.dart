import 'package:flutter/material.dart';
import 'package:inteligentny_dom_5/app/root_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const RootPage());
  }
}

// Here you can manage your theme later
ThemeData buildTheme(


) {
  final ThemeData base = ThemeData();
  return base.copyWith();
}




