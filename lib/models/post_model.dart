class PostModel {
  final String id;
  final String username;
  final String profileImageUrl;
  final List<String> postImages;
  final String caption;
  bool isLiked;
  bool isSaved;
  bool isReel;
  int commentCount;
  int repostCount;
  int shareCount;
  int likesCount;
  int time;

  PostModel({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.postImages,
    required this.caption,
    this.isLiked = false,
    this.isSaved = false,
    this.isReel = false,
    this.likesCount = 0,
    this.commentCount = 0,
    this.repostCount = 0,
    this.shareCount = 0,
    this.time = 1,
  });
}
