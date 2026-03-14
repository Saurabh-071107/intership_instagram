import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../widgets/story_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/shimmer_loading.dart';

import '../widgets/reels_section.dart';
import '../widgets/reel_post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showHeartDot = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(
            'Instagram',
            style: TextStyle(
              fontFamily: 'Billabong',
              fontWeight: FontWeight.w500,
              fontSize: 35,
            ),
          ),
        ),
        leading: Icon(Icons.add ,size: 30,),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite_border, size: 30),
                if (_showHeartDot)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border:Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _showHeartDot = false;
              });
            },
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.posts.isEmpty && postProvider.isLoading) {
            return const ShimmerPostList();
          }
          
          final int postsCount = postProvider.posts.length;

          return RefreshIndicator(
            onRefresh: () => postProvider.loadInitialPosts(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: postsCount + 2 + (postProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) return const StoriesSection();

                if (index == 2) return const ReelsSection();
                if (index == postsCount + 2 && postProvider.isLoading) {
                   return const Padding(
                     padding: EdgeInsets.symmetric(vertical: 20),
                     child: ShimmerPostItem(),
                   );
                }
                int postIndex;
                if (index == 1) {
                  postIndex = 0;
                } else if (index > 2 && index < postsCount + 2) {
                  postIndex = index - 2;
                } else {
                  return const SizedBox.shrink();
                }

                if (postIndex >= postsCount) return const SizedBox.shrink();

                if (postIndex == postsCount - 2 && !postProvider.isLoading && postProvider.hasMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    postProvider.loadMorePosts();
                  });
                }

                final post = postProvider.posts[postIndex];
                if (post.isReel) return ReelPostWidget(post: post);
                return PostWidget(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
