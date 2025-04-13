import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hajj_page.dart';

class ApiService {
  static const String baseUrl =
      'https://rest.lskit.com/wp-json/wp/v2/hajj_pages/';
  static const String cacheKey = 'cached_hajj_pages';

  Future<List<HajjPage>> fetchHajjPages() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // ✅ Save to local cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(cacheKey, response.body);

        return data.map((json) => HajjPage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Hajj pages');
      }
    } catch (_) {
      // ❌ API fail করলে লোকাল ডেটা রিটার্ন
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((json) => HajjPage.fromJson(json)).toList();
      } else {
        rethrow;
      }
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

  Future<HajjPage> fetchHajjPageBySlug(String slug) async {
    final response = await http.get(
      Uri.parse('https://rest.lskit.com/wp-json/wp/v2/hajj_pages?slug=$slug'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return HajjPage.fromJson(data[0]);
      } else {
        throw Exception('No page found for slug: $slug');
      }
    } else {
      throw Exception('Failed to load page for slug: $slug');
    }
  }
}
