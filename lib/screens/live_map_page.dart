import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../services/api_service.dart';
import '../models/hajj_page.dart';

class LiveMapPage extends StatelessWidget {
  const LiveMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🗺️ লাইভ ম্যাপ"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<HajjPage>(
        future: ApiService().fetchHajjPageBySlug('live-map'), // ✅ Correct slug
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No map data found"));
          }

          final acf = snapshot.data!.acf ?? {};
          final blocks = acf['content_blocks'] ?? [];
          List<dynamic> imageInfo = [];

          for (var block in blocks) {
            if (block['acf_fc_layout'] == 'live_map' &&
                block['image_info'] is List) {
              imageInfo = block['image_info'];
              break;
            }
          }

          if (imageInfo.isEmpty) {
            return const Center(child: Text("No image maps available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: imageInfo.length,
            itemBuilder: (context, index) {
              final item = imageInfo[index];
              final imageUrl = item['image_url'] ?? '';
              final title = item['title'] ?? '';
              final desc = item['desc'] ?? '';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => ZoomImagePopup(imageUrl: imageUrl),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageUrl.isNotEmpty
                                  ? imageUrl
                                  : 'https://via.placeholder.com/300x180?text=Image+Missing',
                              fit: BoxFit.cover,
                              height: 180,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) {
                                print('❌ Image failed: $imageUrl');
                                return const Icon(Icons.broken_image, size: 40);
                              },
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 8,
                          right: 8,
                          child: Text(
                            '📍 Tap to zoom',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              backgroundColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            desc,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ZoomImagePopup extends StatelessWidget {
  final String imageUrl;

  const ZoomImagePopup({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.arrow_downward, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
