import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/post_provider.dart';
import '../models/story_model.dart';
import '../utils/custom_snackbar.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 131,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1.0)
            ),
          ),
          child: provider.isLoadingStories && provider.stories.isEmpty
              ? const StoryLoadingList()
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.stories.length,
            itemBuilder: (context, index) {
              return StoryWidget(story: provider.stories[index]);
            },
          ),
        );
      },
    );
  }
}

class StoryLoadingList extends StatelessWidget {
  const StoryLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomSnackbar.show(context, 'Story viewing is coming soon!'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(3.7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: (story.username == 'Your Story')
                    ? null
                    : const LinearGradient(
                  colors: [
                    Color(0xFFF58529),
                    Color(0xFFFEDA77),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF),
                    Color(0xFF515BD4),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                color: (story.username != 'Your Story' && !story.isLive) ? null : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(4.2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: story.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                           const Icon(Icons.person, color: Colors.grey),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    if (story.username == 'Your Story')
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                story.username,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
