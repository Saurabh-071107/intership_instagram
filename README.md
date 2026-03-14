# Instagram Clone (Flutter)

A simplified **Instagram Home Feed clone built using Flutter**.  
This project recreates key UI and interaction patterns of Instagram including posts, stories, reels preview, and infinite scrolling.

The purpose of this project is to demonstrate **Flutter UI development, modular architecture, and efficient state management using Provider**.

---

# Features

- Instagram-style **Home Feed**
- **Stories section** with gradient ring
- **Post cards** with username, caption, and timestamp
- **Like, comment, share, and save actions**
- **Carousel posts** with swipe gestures
- **Inline reel-style posts**
- **Infinite scrolling feed**
- **Pull-to-refresh functionality**
- **Image caching**
- **Shimmer loading skeleton while fetching posts**

---

# Project Architecture

The project follows a **clean modular architecture** to keep UI, business logic, and data layers separated.

lib/
│
├── main.dart # Application entry point
│
├── models/
│ └── post_model.dart # Data model for posts
│
├── repositories/
│ └── post_repository.dart # Mock API / data provider
│
├── providers/
│ └── post_provider.dart # State management using Provider
│
├── screens/
│ ├── main_screen.dart # Bottom navigation container
│ └── home_screen.dart # Home feed UI
│
└── widgets/
├── story_widget.dart
├── post_widget.dart
├── reel_post_widget.dart
├── reels_section.dart
├── post_header.dart
├── post_actions.dart
├── carousel_widget.dart
└── shimmer_loading.dart


This structure improves:

- code readability
- maintainability
- scalability

---

# State Management

This project uses **Provider with ChangeNotifier** for state management.

### Why Provider?

Provider was chosen because:

- It is **recommended by the Flutter team**
- It enables **efficient UI updates**
- It separates **business logic from UI**
- It is lightweight and suitable for medium-sized applications

### Implementation

The application state is managed using **PostProvider**, which:

- Loads posts from the repository
- Handles pagination (infinite scroll)
- Updates like/save states
- Notifies the UI when state changes

Example:

```dart
class PostProvider with ChangeNotifier {

  final List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  void toggleLike(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.isLiked = !post.isLiked;
    notifyListeners();
  }

}


The provider is registered globally in main.dart:

MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => PostProvider()..loadInitialPosts(),
    ),
  ],
  child: MyApp(),
)


This allows widgets across the app to access and react to state changes.

Dependencies

The project uses the following Flutter packages:

Package	Purpose
provider	State management
cached_network_image	Efficient image loading and caching
smooth_page_indicator	Carousel dot indicators
shimmer	Skeleton loading animation
Requirements

Before running the project ensure the following are installed:

Flutter SDK 3.x or later

Dart SDK 3.x

Android Studio or VS Code

Android Emulator / iOS Simulator or physical device

Running the Project
1 Clone the Repository
git clone https://github.com/<your-username>/<repository-name>.git

2 Navigate to the Project Directory
cd <repository-name>

3 Install Dependencies
flutter pub get

4 Run the Application
flutter run

Download and Run via GitHub Release

You can also download the project directly from GitHub Releases.

Steps:

Go to the Releases section of this repository.

Download the latest Source Code (.zip).

Extract the zip file.

Open the project in Android Studio or VS Code.

Run the following commands:

flutter pub get
flutter run
