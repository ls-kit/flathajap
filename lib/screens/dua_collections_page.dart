import 'package:flutter/material.dart';
import '../models/hajj_page.dart';
import '../services/api_service.dart';

class DuaCollectionsPage extends StatelessWidget {
  const DuaCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('গুরুত্বপূর্ন দোয়া'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<HajjPage>(
        future: apiService.fetchHajjPageById(24),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final acf = snapshot.data!.acf ?? {};
          final blocks = acf['content_blocks'] as List<dynamic>? ?? [];

          List<dynamic> duaList = [];

          for (var block in blocks) {
            if (block['acf_fc_layout'] == 'steps_block' &&
                block['important_dua'] is List) {
              duaList = block['important_dua'];
              break;
            }
          }

          if (duaList.isEmpty) {
            return const Center(child: Text('No Duas found.'));
          }

          // Print to console
          for (var dua in duaList) {
            debugPrint('🕌 ${dua['dua_name']}');
            debugPrint('🕋 ${dua['arabic_text']}');
            debugPrint('🔊 ${dua['bangla_pronunciation']}');
            debugPrint('💬 ${dua['bengali_meaning']}');
          }

          // Display in app
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: duaList.length,
            itemBuilder: (context, index) {
              final dua = duaList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🕌 ${dua['dua_name'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '🕋 ${dua['arabic_text'] ?? ''}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontFamily: 'Scheherazade',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '🔊 ${dua['bangla_pronunciation'] ?? ''}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '💬 ${dua['bengali_meaning'] ?? ''}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
