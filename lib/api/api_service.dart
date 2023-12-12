import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'API_KEY'; // Replace with your API key
  final String baseUrl = 'https://www.exchangerate-api.com/';

  Future<Map<String, dynamic>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}