class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final String banner;
  final bool isAuthenticated;
  final int karma;
  final List<String> awards;

  const UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
      banner: json['banner'] as String,
      isAuthenticated: json['isAuthenticated'] as bool,
      karma: json['karma'] as int,
      awards: List<String>.from(json['awards'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
    String? banner,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }
}
