class PhotoPostModel {
  const PhotoPostModel({
    required this.image,
    required this.author,
    required this.likes,
    required this.comment,
  });

  final String image;
  final String author;
  final int likes;
  final String comment;

  Map<String, dynamic> toJson() => {
        'image': image,
        'author': author,
        'likes': likes,
        'comment': comment,
      };

  factory PhotoPostModel.fromJson(dynamic json) => PhotoPostModel(
        image: json['image'],
        author: json['author'],
        likes: json['likes'],
        comment: json['comment'],
      );
}
