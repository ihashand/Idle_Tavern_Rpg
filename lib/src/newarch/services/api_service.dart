import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> getExpeditions() async {
    var response = await http.get(Uri.parse('$baseUrl/expeditions'));
    return json.decode(response.body);
  }

  // Dodaj więcej metod dla innych typów żądań i danych
}
