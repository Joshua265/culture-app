class Content {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String genre;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.genre,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
      genre: json['genre'],
    );
  }
}
