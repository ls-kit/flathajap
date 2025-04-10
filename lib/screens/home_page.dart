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
                final icon = _getIcon(page.slug);
                final bgColor = _getColor(page.slug);

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
                      color: bgColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: bgColor, width: 1),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: bgColor, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  // 🌟 Icon based on slug
  IconData _getIcon(String slug) {
    switch (slug) {
      case 'checklist':
        return Icons.check_circle_outline;
      case 'dua_collections':
        return Icons.menu_book;
      case 'live-map':
        return Icons.map_outlined;
      case 'hajj_steps':
        return Icons.directions_walk;
      default:
        return Icons.article;
    }
  }

  // 🎨 Color per slug
  Color _getColor(String slug) {
    switch (slug) {
      case 'checklist':
        return Colors.teal;
      case 'dua_collections':
        return Colors.deepOrange;
      case 'live-map':
        return Colors.indigo;
      case 'hajj_steps':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
