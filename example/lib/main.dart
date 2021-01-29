import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FormBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blueAccent),
        ),
      ),
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fr', ''),
        Locale('ja', ''),
        Locale('pt', ''),
        Locale('sk', ''),
      ],
      home: HomePage(),
    );
  }
}