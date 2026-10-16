import 'dart:async';
import 'package:angel3_framework/angel3_framework.dart';

Future configureServer(Angel app) async {
  int _counter = 0;
  app.get("/auth/login", (req, res) {
    res.write('Hello, world! $_counter');
  });
  app.get("/auth/logout", (req, res) {
    res.write('Goodbye, world! $_counter');
  });
}
