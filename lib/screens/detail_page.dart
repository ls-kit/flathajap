import 'package:flutter/material.dart';
import '../models/hajj_page.dart';
import '../services/api_service.dart';

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Hajj Page Details')),
      body: FutureBuilder<HajjPage>(
        future: apiService.fetchHajjPageById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final hajjPage = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hajjPage.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Slug: ${hajjPage.slug}'),
                const SizedBox(height: 8),
                Text('Link: ${hajjPage.link}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
