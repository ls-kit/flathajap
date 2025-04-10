class HajjPage {
  final int id;
  final String title;
  final String slug;
  final String link;
  final Map<String, dynamic>? acf;

  HajjPage({
    required this.id,
    required this.title,
    required this.slug,
    required this.link,
    this.acf,
  });

  factory HajjPage.fromJson(Map<String, dynamic> json) {
    return HajjPage(
      id: json['id'],
      title: json['title']['rendered'],
      slug: json['slug'],
      link: json['link'],
      acf: json['acf'], // Ensure this is included
    );
  }
}
