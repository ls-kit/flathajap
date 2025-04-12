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

class HajjHomeScreen extends StatefulWidget {
  const HajjHomeScreen({super.key});

  @override
  State<HajjHomeScreen> createState() => _HajjHomeScreenState();
}

class _HajjHomeScreenState extends State<HajjHomeScreen> {
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
    if (forceDetail) {
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
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'গাইড'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'মানচিত্র'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'সেটিংস'),
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
                          const Icon(Icons.menu, size: 28),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'স্বাগতম!',
                                style: boldTextStyle(
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'হজ গাইড অ্যাপে',
                                style: secondaryTextStyle(size: 14),
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
                                  Icons.menu_book,
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
                            hajjPages.map((item) {
                              return StaggeredGridTile.fit(
                                crossAxisCellCount: 2,
                                child: GestureDetector(
                                  onTap: () => openPageBySlug(context, item),
                                  child: Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: Colors.white,
                                      borderRadius: radius(16),
                                      boxShadow: defaultBoxShadow(),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.star_border,
                                          color: Colors.orange,
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
                  ],
                ),
      ),
    );
  }
}
