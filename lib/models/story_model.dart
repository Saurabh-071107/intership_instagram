class StoryModel {
  final String id;
  final String username;
  final String imageUrl;
  final bool isLive;

  StoryModel({
    required this.id,
    required this.username,
    required this.imageUrl,
    this.isLive = false,
  });
}
