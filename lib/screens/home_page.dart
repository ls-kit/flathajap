import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';
import '../services/api_service.dart';
import '../models/hajj_page.dart';
import 'checklist_page.dart';
import 'dua_collections_page.dart';
import 'live_map_page.dart';
import 'settings_about_page.dart';
import 'detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HajjHomeScreen extends StatefulWidget {
  const HajjHomeScreen({super.key});

  @override
  State<HajjHomeScreen> createState() => _HajjHomeScreenState();
}

class _HajjHomeScreenState extends State<HajjHomeScreen> {
  IconData getPageIcon(String slug) {
    if (slug.contains('checklist')) return Icons.checklist_rounded;
    if (slug.contains('dua')) return Icons.menu_book_rounded;
    if (slug.contains('live-map')) return Icons.location_on_rounded;
    if (slug.contains('steps')) return Icons.format_list_numbered_rounded;
    if (slug.contains('settings_about')) return Icons.support_agent_rounded;
    return Icons.auto_awesome_rounded; // fallback icon
  }

  late List<HajjPage> hajjPages = [];
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await ApiService().fetchHajjPages();
      setState(() {
        hajjPages = data;
        isLoading = false;
      });
    } catch (e) {
      toast('Failed to load data');
    }
  }

  void openPageBySlug(
    BuildContext context,
    HajjPage page, {
    bool forceDetail = false,
  }) {
    if (forceDetail || page.slug.trim().isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(id: page.id)),
      );
      return;
    }

    switch (page.slug) {
      case 'checklist':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChecklistPage()),
        );
        break;
      case 'dua_collections':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DuaCollectionsPage()),
        );
        break;
      case 'live-map':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LiveMapPage()),
        );
        break;
      case 'settings_about':
      case 'hajj_steps':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsAboutPage()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(id: page.id)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            if (hajjPages.isNotEmpty) {
              switch (index) {
                case 1:
                  final guide = hajjPages.firstWhere(
                    (e) => e.slug == 'checklist',
                    orElse: () => hajjPages[0],
                  );
                  openPageBySlug(context, guide);
                  break;
                case 2:
                  final map = hajjPages.firstWhere(
                    (e) => e.slug == 'live-map',
                    orElse: () => hajjPages[0],
                  );
                  openPageBySlug(context, map);
                  break;
                case 3:
                  final settings = hajjPages.firstWhere(
                    (e) => e.slug == 'settings_about',
                    orElse: () => hajjPages[0],
                  );
                  openPageBySlug(context, settings);
                  break;
              }
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'হোম'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'গাইড',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'মানচিত্র',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'সেটিংস',
          ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.apps_rounded,
                            size: 32,
                            color: Colors.green,
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'স্বাগতম! হজ গাইড অ্যাপে',
                                style: boldTextStyle(
                                  size: 22,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                ' আপনার হজ যাত্রার সেরা সহচর।\nপ্রতিটি ধাপ সহজ ভাষায়, প্রয়োজনীয় দোয়া, মানচিত্র এবং চেকলিস্টসহ।',
                                style: secondaryTextStyle(size: 13),
                                maxLines: 3,
                              ),
                            ],
                          ).expand(),
                          const Icon(Icons.search, color: Colors.grey),
                        ],
                      ),
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '📚 গাইড বিভাগসমূহ',
                        style: boldTextStyle(size: 18),
                      ),
                    ),
                    12.height,
                    HorizontalList(
                      itemCount: hajjPages.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final item = hajjPages[index];
                        return GestureDetector(
                          onTap:
                              () => openPageBySlug(
                                context,
                                item,
                                forceDetail: index == 0,
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: Colors.green.shade50,
                              borderRadius: radius(12),
                              boxShadow: defaultBoxShadow(
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 32,
                                  color: Colors.green,
                                ),
                                8.height,
                                Text(
                                  item.title,
                                  style: primaryTextStyle(size: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    24.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🕌 সেরা বিষয়সমূহ',
                            style: boldTextStyle(size: 18, color: Colors.green),
                          ),
                          Text('সব দেখুন', style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children:
                            hajjPages.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return StaggeredGridTile.fit(
                                crossAxisCellCount: 2,
                                child: GestureDetector(
                                  onTap:
                                      () => openPageBySlug(
                                        context,
                                        item,
                                        forceDetail: index == 0,
                                      ),
                                  child: Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: Colors.white,
                                      borderRadius: radius(16),
                                      boxShadow: defaultBoxShadow(),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Icon(
                                          getPageIcon(item.slug),
                                          color: Colors.green.shade700,
                                          size: 40,
                                        ),
                                        8.height,
                                        Text(
                                          item.title,
                                          style: primaryTextStyle(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    50.height,
                    // 👇 Developer Contact Card
                    // 👇 Developer Contact Card with WhatsApp
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          const phone = '+8801876777411';
                          const message = 'হজ্ব এপ থেকে যোগাযোগ করা হল';
                          final url =
                              'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            toast('Could not open WhatsApp');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: Colors.green.shade100,
                            borderRadius: radius(16),
                            boxShadow: defaultBoxShadow(),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/dev.png', // 📷 Replace with actual image
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(12),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'আপনার নিজের অ্যান্ড্রয়েড অ্যাপ চান?',
                                      style: boldTextStyle(size: 14),
                                    ),
                                    4.height,
                                    Text(
                                      'আমাদের ডেভেলপার টিমের সাথে যোগাযোগ করুন। যেকোনো আইডিয়া থেকে অ্যাপ বানাতে সাহায্য করা হবে।',
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                    8.height,
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.chat,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                        6.width,
                                        Text(
                                          'WhatsApp: +8801876777411',
                                          style: primaryTextStyle(size: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
