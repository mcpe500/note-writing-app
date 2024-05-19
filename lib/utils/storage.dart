import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveArray(String arrayName, List<String> array) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the array to a JSON string
  String jsonString = jsonEncode(array);

  await prefs.setString(arrayName, jsonString);
}

Future<List<String>> loadArray(String arrayName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get the JSON string from local storage
  String? jsonString = prefs.getString(arrayName);

  // If the key does not exist, return an empty array
  if (jsonString == null) {
    return [];
  }

  // Decode the JSON string back into an array
  List<String> array = List<String>.from(jsonDecode(jsonString));

  return array;
}
