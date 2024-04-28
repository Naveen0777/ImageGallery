import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiKey = '43439204-39d293ba3ec4e8091e2b45420';

  static Future<List<dynamic>> fetchImages(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://pixabay.com/api/?key=$apiKey&q=$query&image_type=photo'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['hits'];
      } else {
        throw Exception(
            'Failed to load images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load images. Error: $e');
    }
  }
}
