import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveArray(String arrayName, List<String> array) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(array);
  await prefs.setString(arrayName, jsonString);
}

Future<List<String>> loadArray(String arrayName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(arrayName);
  if (jsonString == null) {
    return [];
  }
  List<String> array = List<String>.from(jsonDecode(jsonString));
  return array;
}
