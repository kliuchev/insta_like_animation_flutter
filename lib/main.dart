import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_like_animation_flutter/photo_post/photo_post.dart';
import 'package:insta_like_animation_flutter/photo_post/photo_post_model.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Like button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _scrollController = ScrollController();

  List<PhotoPostModel> _posts = [];

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/posts.json').then((json) {
      final rawPosts = jsonDecode(json) as List<dynamic>;
      final photoPosts = rawPosts.map(PhotoPostModel.fromJson).toList();

      setState(() {
        _posts = photoPosts;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          controller: _scrollController,
          itemCount: _posts.length,
          itemBuilder: (context, index) => Provider.value(
            value: _posts[index],
            child: const PhotoPost(),
          ),
        ),
      );
}
