import 'dart:convert';
import 'package:myapp/services/index.dart';
import 'package:myapp/services/storage.dart';

Future<bool> loginUser(String username, String password) async {
  final response = await apiService.post('auth/login', body: {
    'username': username,
    'password': password,
  });
  StorageService storage = await StorageService.getInstance();

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    String accessToken = responseBody['accessToken'];

    await storage.saveString('accessToken', accessToken);

    return responseBody['success'];
  } else {
    throw Exception('Failed to login user');
  }
}
