import 'package:flutter/material.dart';
import '../models/hajj_page.dart';
import '../services/api_service.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রস্তুতির পরামর্শ'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<HajjPage>(
        future: apiService.fetchHajjPageBySlug('checklist'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final acf = snapshot.data!.acf ?? {};
          final blocks = acf['content_blocks'] ?? [];
          List<dynamic> dateTitles = [];

          for (var block in blocks) {
            if (block['acf_fc_layout'] == 'checklist' &&
                block['date_title'] is List) {
              dateTitles = block['date_title'];
              break;
            }
          }

          if (dateTitles.isEmpty) {
            return const Center(child: Text('No checklist data found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dateTitles.length,
            itemBuilder: (context, index) {
              final day = dateTitles[index];
              final dayTitle = day['title'] ?? 'Untitled Day';
              final steps = day['details_step'] as List<dynamic>? ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📅 $dayTitle',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...steps.map((step) {
                    return ListTile(
                      leading: Text(step['icon'] ?? '📌'),
                      title: Text(step['title'] ?? ''),
                      subtitle: Text(step['desc'] ?? ''),
                    );
                  }).toList(),
                  const Divider(height: 32),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
