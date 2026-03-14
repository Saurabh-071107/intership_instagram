import '../models/post_model.dart';
import '../models/story_model.dart';
import 'dart:math';

class PostRepository {
  Future<List<StoryModel>> fetchStories() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    return List.generate(10, (index) {
      return StoryModel(
        id: index.toString(),
        username: index == 0 ? 'Your Story' : 'user_$index',
        imageUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
        isLive: index == 3,
      );
    });
  }

  Future<List<PostModel>> fetchPosts({int startIndex = 0, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    return List.generate(limit, (index) {
      int id = startIndex + index;
      bool hasCarousel = id % 3 == 0;
      bool isReelItem = !hasCarousel && (id % 4 == 2);
      
      List<String> images = [
        'https://picsum.photos/seed/${id}_1/800/${isReelItem ? 1200 : 800}',
      ];
      if (hasCarousel) {
        images.add('https://picsum.photos/seed/${id}_2/800/800');
        images.add('https://picsum.photos/seed/${id}_3/800/800');
      }

      return PostModel(
        id: id.toString(),
        username: 'user_$id',
        profileImageUrl: 'https://i.pravatar.cc/150?img=${id % 70}',
        postImages: images,
        caption: 'This is a mocked caption for post $id. #flutter #instagram_clone',
        isLiked: false,
        isSaved: false,
        isReel: isReelItem,
        likesCount: Random().nextInt(100),
        commentCount: Random().nextInt(100),
        repostCount: Random().nextInt(100),
        shareCount: Random().nextInt(100),
        time: Random().nextInt(24),
      );
    });
  }
}