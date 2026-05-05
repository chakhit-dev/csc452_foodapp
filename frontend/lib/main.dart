import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Food Calorie App',
        theme: ThemeData(primarySwatch: Colors.green),
        home: HomeScreen(),
      ),
    ),
  );
}