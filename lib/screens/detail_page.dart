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
      appBar: AppBar(
        title: const Text(
          'হজ্জ গাইড',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: FutureBuilder<HajjPage>(
        future: apiService.fetchHajjPageById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final hajjPage = snapshot.data!;
          final contentBlocks = hajjPage.acf?['content_blocks'] ?? [];

          // Check for specific ACF layout types
          final stepByGuideBlock = contentBlocks.firstWhere(
            (block) => block['acf_fc_layout'] == 'step_by_guide',
            orElse: () => null,
          );

          if (stepByGuideBlock != null) {
            final hajjSteps = stepByGuideBlock['hajj_st'] ?? [];
            return buildStepGuide(hajjSteps);
          }

          // Fallback if no specific layout is found
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              hajjPage.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget buildStepGuide(List<dynamic> hajjSteps) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: hajjSteps.length,
      itemBuilder: (context, index) {
        final step = hajjSteps[index];
        final icon = step['icon'] ?? ''; // Default icon if empty
        final title = step['title'] ?? 'Untitled';
        final desc = step['desc'] ?? 'No description available';

        return HajjStepCard(icon: icon, title: title, description: desc);
      },
    );
  }
}

class HajjStepCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const HajjStepCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Section
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  icon.isNotEmpty ? icon : '📘', // Default icon
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Title and Description Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
