import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../repositories/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _repository = PostRepository();
  final List<PostModel> _posts = [];
  final List<StoryModel> _stories = [];
  bool _isLoading = false;
  bool _isLoadingStories = false;
  bool _hasMore = true;

  List<PostModel> get posts => _posts;
  List<StoryModel> get stories => _stories;
  bool get isLoading => _isLoading;
  bool get isLoadingStories => _isLoadingStories;
  bool get hasMore => _hasMore;

  Future<void> loadStories() async {
    if (_isLoadingStories) return;
    _isLoadingStories = true;
    notifyListeners();

    try {
      final newStories = await _repository.fetchStories();
      _stories.clear();
      _stories.addAll(newStories);
    } catch (e) {
      debugPrint("Error fetching stories: $e");
    } finally {
      _isLoadingStories = false;
      notifyListeners();
    }
  }

  Future<void> loadInitialPosts() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    loadStories();

    try {
      final newPosts = await _repository.fetchPosts(startIndex: 0, limit: 10);
      _posts.clear();
      _posts.addAll(newPosts);
      _hasMore = newPosts.length == 10;
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newPosts = await _repository.fetchPosts(startIndex: _posts.length, limit: 10);
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(newPosts);
        _hasMore = newPosts.length == 10;
      }
    } catch (e) {
      debugPrint("Error fetching more posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    try {
      var post = _posts.firstWhere((p) => p.id == postId);
      post.isLiked = !post.isLiked;
      post.likesCount += post.isLiked ? 1 : -1;
      notifyListeners();
    } catch (e) {
    }
  }

  void toggleSave(String postId) {
    try {
      var post = _posts.firstWhere((p) => p.id == postId);
      post.isSaved = !post.isSaved;
      notifyListeners();
    } catch (e) {
    }
  }
}
