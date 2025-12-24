import 'package:intellimeal/models/user_model.dart';

class UserLocal {
  final String token;
  final User user;

  UserLocal({
    required this.token,
    required this.user,
  });

  factory UserLocal.fromJson(Map<String, dynamic> json) => UserLocal(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}
