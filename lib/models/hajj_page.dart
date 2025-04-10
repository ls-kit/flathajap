class HajjPage {
  final int id;
  final String title;
  final String slug;
  final String link;

  HajjPage({
    required this.id,
    required this.title,
    required this.slug,
    required this.link,
  });

  factory HajjPage.fromJson(Map<String, dynamic> json) {
    return HajjPage(
      id: json['id'],
      title: json['title']['rendered'],
      slug: json['slug'],
      link: json['link'],
    );
  }
}
