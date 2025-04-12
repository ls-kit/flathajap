import 'package:flutter/material.dart';
import '../models/hajj_page.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HajjPage>(
      future: ApiService().fetchHajjPageBySlug('settings_about'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('ত্রুটি'),
              backgroundColor: Colors.green,
              centerTitle: true,
            ),
            body: Center(child: Text('Error: \${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('তথ্য নেই'),
              backgroundColor: Colors.green,
              centerTitle: true,
            ),
            body: const Center(child: Text('No data found')),
          );
        }

        final hajjPage = snapshot.data!;
        final acf = hajjPage.acf ?? {};
        final subTitle = acf['sub_title'] ?? '';
        final contentBlocks = acf['content_blocks'] ?? [];

        List<dynamic> helpSections = [];
        for (var block in contentBlocks) {
          if (block['acf_fc_layout'] == 'help_desk' &&
              block['help_sec'] is List) {
            helpSections = block['help_sec'];
            break;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(hajjPage.title),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: helpSections.length,
            itemBuilder: (context, index) {
              final section = helpSections[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        section['desc'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      if ((section['btn_link'] ?? '').toString().contains('@'))
                        ElevatedButton.icon(
                          icon: const Icon(Icons.mail),
                          label: Text(section['btn_text'] ?? 'যোগাযোগ করুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final email = section['btn_link'] ?? '';
                            final uri = Uri(scheme: 'mailto', path: email);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ইমেইল পাঠানো যায়নি!'),
                                ),
                              );
                            }
                          },
                        )
                      else if ((section['btn_link'] ?? '')
                          .toString()
                          .startsWith('http'))
                        ElevatedButton.icon(
                          icon: const Icon(Icons.link),
                          label: Text(section['btn_text'] ?? 'আরও জানুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final link = section['btn_link'] ?? '';
                            final uri = Uri.parse(link);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('লিঙ্ক খোলা যায়নি!'),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
