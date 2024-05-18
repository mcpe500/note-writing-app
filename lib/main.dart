import 'package:flutter/material.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the routes
      routes: {
        'home': (context) => const HomeApp(),
        'login': (context) => const LoginApp(), // Your login page
      },
      initialRoute: 'login',
    );
  }
}
