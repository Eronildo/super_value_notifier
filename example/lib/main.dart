import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:super_value_notifier/super_value_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterWidget(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final asyncResult = resultPosts.watch(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Super Value Notifier'),
      ),
      body: Center(
        child: asyncResult.when(
          data: (posts) => ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(posts[index].body),
            ),
          ),
          error: (error, stackTrace) => Text('$error'),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: asyncResult.isLoading ? null : resultPosts.reload,
        backgroundColor:
            asyncResult.isLoading ? Colors.grey : Colors.yellowAccent,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListenableListener(
        listenable: counterNotifier,
        listener: () {
          debugPrint('LISTENER: ${counterNotifier.counter}');
        },
        child: ListenableConsumer(
          listenable: counterNotifier,
          listener: () {
            debugPrint('Counter: ${counterNotifier.counter}');
          },
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Counter: ${counterNotifier.counter}'),
                  ElevatedButton(
                    onPressed: counterNotifier.increment,
                    child: const Text('Increment'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final repository = PostsRepository();
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

final counterNotifier = CounterNotifier();

class CounterNotifier extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
