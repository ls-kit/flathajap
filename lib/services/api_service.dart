import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hajj_page.dart';

class ApiService {
  static const String baseUrl =
      'https://rest.lskit.com/wp-json/wp/v2/hajj_pages/';

  Future<List<HajjPage>> fetchHajjPages() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => HajjPage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Hajj pages');
    }
  }

  Future<HajjPage> fetchHajjPageById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id'));
    if (response.statusCode == 200) {
      return HajjPage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Hajj page');
    }
  }
}
