class User {
  String id;
  String username;
  String mail;
  String pictureUrl;

  User(
      {required this.id,
      required this.username,
      required this.mail,
      required this.pictureUrl});

  factory User.empty() => User(id: '', username: '', mail: '', pictureUrl: '');

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      mail: json['email'] as String,
      pictureUrl: json['pictureUrl'] as String);
}
