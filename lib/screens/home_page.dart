import 'package:flutter/material.dart';
import '../models/hajj_page.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'checklist_page.dart';
import 'dua_collections_page.dart';
import 'live_map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🕋 হজ্ব গাইড"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<HajjPage>>(
        future: ApiService().fetchHajjPages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('কোনো তথ্য পাওয়া যায়নি'));
          }

          final pages = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: pages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final page = pages[index];
                return GestureDetector(
                  onTap: () {
                    // 🔀 Navigate based on slug
                    switch (page.slug) {
                      case 'checklist':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChecklistPage(),
                          ),
                        );
                        break;
                      case 'dua_collections':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DuaCollectionsPage(),
                          ),
                        );
                        break;
                      case 'live-map':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LiveMapPage(),
                          ),
                        );
                        break;

                      default:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(id: page.id),
                          ),
                        );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        page.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
