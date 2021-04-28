import 'package:flutter/material.dart';

import 'constants.dart';
import 'price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: kDarkPrimaryColor,
        scaffoldBackgroundColor: kLightPrimaryColor,
      ),
      home: PriceScreen(),
    );
  }
}
