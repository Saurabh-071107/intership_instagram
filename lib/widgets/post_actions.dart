import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../models/post_model.dart';
import '../utils/custom_snackbar.dart';

class PostActions extends StatefulWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool liked = false;
  bool repost = false;

  void _showUnimplementedSnackbar(BuildContext context, String feature) {
    CustomSnackbar.show(context, '$feature feature is coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final currentPost = provider.posts.firstWhere(
                (p) => p.id == widget.post.id,
            orElse: () => widget.post,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              liked = !liked;
                              if (liked) {
                                currentPost.likesCount++;
                              } else {
                                currentPost.likesCount--;
                              }
                              });
                          },
                          child: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: liked ? Colors.red : Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                       Padding(
                           padding: const EdgeInsets.symmetric(horizontal:1.0),
                           child: Text(
                           '${currentPost.likesCount } ',
                           style: const TextStyle(fontWeight: FontWeight.bold),
                         ),
                       ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () => _showUnimplementedSnackbar(context, 'Comments'),
                        child: const Icon(Icons.chat_bubble_outline, size: 26, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:1.0),
                    child: Text(
                      '${currentPost.commentCount } ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            repost = !repost;
                            if (repost) {
                              currentPost.repostCount++;
                            } else {
                              currentPost.repostCount--;
                            }
                          });
                        },
                        child: Icon(
                          Icons.repeat_rounded, 
                          size: 28, 
                          color: repost ? Colors.green : Colors.black
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:1.0),
                    child: Text(
                      '${currentPost.repostCount } ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => _showUnimplementedSnackbar(context, 'Share'),
                      child: const Icon(Icons.send_outlined, size: 26, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:1.0),
                    child: Text(
                      '${currentPost.shareCount } ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  currentPost.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () => provider.toggleSave(currentPost.id),
              ),
            ],
          ),
        );
      }
    );
  }
}
