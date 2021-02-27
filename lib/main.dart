import 'package:amazing_company/screens/detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:amazing_company/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'models/search_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SeachHelper(),
      child: MaterialApp(
        title: 'Amazing App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(title: 'Amazing App'),
        routes: {
          DetailScreen.routeName : (ctx) => DetailScreen(),
        },
      ),
    );
  }
}
