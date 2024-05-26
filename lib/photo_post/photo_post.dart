import 'package:flutter/material.dart';
import 'package:insta_like_animation_flutter/photo_post/follor_button.dart';
import 'package:insta_like_animation_flutter/photo_post/like_surface.dart';
import 'package:insta_like_animation_flutter/photo_post/photo_post_model.dart';
import 'package:provider/provider.dart';

// PhotoPost is a widget that displays a photo post.
// It shows the user avatar, the post title, a follow button, a more button,
// the post image, the number of likes, and the post description.

class PhotoPost extends StatelessWidget {
  const PhotoPost({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(),
              SizedBox(width: 10),
              PostTitle(),
              Spacer(),
              FollowButton(),
              MoreButton(),
            ],
          ),
          PostImage(),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LikedText(),
                PhotoPostDescription(),
              ],
            ),
          ),
        ],
      );

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.width * (4 / 3) + 100;
}

/// The [PostImage] widget displays the image of a post.
class PostImage extends StatelessWidget {
  const PostImage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PhotoPostModel>(context);

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: LikeSurface(
        child: Image.asset(
          post.image,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * (4 / 3),
        ),
      ),
    );
  }
}

class PhotoPostDescription extends StatelessWidget {
  const PhotoPostDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PhotoPostModel>(context);

    return RichText(
      text: TextSpan(
        text: post.author,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: ' ${post.comment}',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class LikedText extends StatelessWidget {
  const LikedText({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PhotoPostModel>(context);

    return Text(
      '${post.likes} likes',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: OpacityButton(
          child: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      );
}

class PostTitle extends StatelessWidget {
  const PostTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PhotoPostModel>(context);
    return Text(
      post.author,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8, right: 4, top: 8, bottom: 8),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('assets/user_pic.jpg'),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
}
