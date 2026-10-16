import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url);
  }

  Future<http.Response> post(String endpoint,
      {required Map<String, String> body}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(url, body: body);
  }

  Future<http.Response> put(String endpoint,
      {required Map<String, String> body}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.put(url, body: body);
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.delete(url);
  }
}
