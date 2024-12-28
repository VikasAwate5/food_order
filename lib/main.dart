import 'package:flutter/material.dart';
import 'package:food_order/src/widget_factory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = WidgetFactory.instance;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: widgetFactory.getFoodOrderDetailsPage(),
    );
  }
}
