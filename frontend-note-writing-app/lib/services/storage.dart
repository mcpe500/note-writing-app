import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._internal();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<void> saveArray(String arrayName, List<String> array) async {
    String jsonString = jsonEncode(array);
    await _preferences!.setString(arrayName, jsonString);
  }

  Future<List<String>> loadArray(String arrayName) async {
    String? jsonString = _preferences!.getString(arrayName);

    if (jsonString == null) {
      return [];
    }

    List<dynamic> decodedJson = jsonDecode(jsonString);
    List<String> array = List<String>.from(decodedJson);
    return array;
  }

  Future<void> saveString(String itemName, String value) async {
    await _preferences!.setString(itemName, value);
  }

  Future<String?> loadString(String itemName) async {
    return _preferences!.getString(itemName);
  }
}
