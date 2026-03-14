import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class PostHeader extends StatefulWidget {
  final String username;
  final String profileImageUrl;

  const PostHeader({
    super.key,
    required this.username,
    required this.profileImageUrl,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: check
                    ? const LinearGradient(
                  colors: [
                    Color(0xFFF58529),
                    Color(0xFFFEDA77),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF),
                    Color(0xFF515BD4),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
                    : null,
                color: check ? null : Colors.grey[300],
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.profileImageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ),

          const SizedBox(width: 10),

              Text(
                widget.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}