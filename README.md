# Super Value Notifier

## Quick Start

```dart
import 'package:super_value_notifier/super_value_notifier.dart';

/// Widget:
final asyncResult = resultPosts.watch(context);
////

final resultPosts = AsyncValueNotifier(repository.fetchPosts);

class PostsRepository {
    Future<List<Post>> fetchPosts() async {
        await Future.delayed(Durations.long4);
        final response =
            await Dio().get('https://jsonplaceholder.typicode.com/posts');
        final posts =
            (response.data as List).map((post) => Post.fromMap(post)).toList();
        return posts;
    }
}

class Post {
    final int userId;
    final int id;
    final String title;
    final String body;

    Post({
        required this.userId,
        required this.id,
        required this.title,
        required this.body,
    });

    factory Post.fromMap(Map<String, dynamic> map) {
        return Post(
        userId: map['userId'] as int,
        id: map['id'] as int,
        title: map['title'] as String,
        body: map['body'] as String,
        );
    }
}

class ComputedController {
    final ValueNotifier<int> counter = ValueNotifier(0);
    final ValueNotifier<int> counter2 = ValueNotifier(0);

    late final computed = computedListenable([counter, counter2], () {
        return counter.value + counter2.value;
    });

    void increment() {
        counter.value++;
    }

    void increment2() {
        counter2.value++;
    }
}
```