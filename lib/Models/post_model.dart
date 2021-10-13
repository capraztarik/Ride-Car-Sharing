class PostModel {
  final String profilePhotoUrl;
  final String username;
  final String uid;
  final String pid;
  final String caption;

  const PostModel(
      {required this.username,
        required this.uid,
        required this.pid,
        required this.profilePhotoUrl,
        required this.caption,
       });

  Map toJson() {
    return {'username': username,
      };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        username: json['username'],
        uid: json['ownerId'],
        pid: json['postId'],
        profilePhotoUrl: json['profilePhotoUrl'],
        caption: json['description'],
    );
  }
}