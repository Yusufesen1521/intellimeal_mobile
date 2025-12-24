// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String token;
  final User user;

  UserModel({
    required this.token,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  final String id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String email;
  final dynamic password;
  final String role;
  final List<PersonalInfo> personalInfo;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.role,
    required this.personalInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    surname: json["surname"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    personalInfo: List<PersonalInfo>.from(
      json["personalInfo"].map((x) => PersonalInfo.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "surname": surname,
    "phoneNumber": phoneNumber,
    "email": email,
    "password": password,
    "role": role,
    "personalInfo": List<dynamic>.from(personalInfo.map((x) => x.toJson())),
  };
}

class PersonalInfo {
  final String id;
  final String userId;
  final DateTime date;
  final int age;
  final double weight;
  final int height;
  final String gender;
  final String activityLevel;
  final String dietaryPreference;
  final String goal;
  final String healthCondition;
  final int neckSize;
  final int waistSize;
  final int hipSize;
  final int chestSize;
  final int armSize;
  final int legSize;

  PersonalInfo({
    required this.id,
    required this.userId,
    required this.date,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.dietaryPreference,
    required this.goal,
    required this.healthCondition,
    required this.neckSize,
    required this.waistSize,
    required this.hipSize,
    required this.chestSize,
    required this.armSize,
    required this.legSize,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    id: json["id"],
    userId: json["userId"],
    date: DateTime.parse(json["date"]),
    age: json["age"],
    weight: json["weight"]?.toDouble(),
    height: json["height"],
    gender: json["gender"],
    activityLevel: json["activityLevel"],
    dietaryPreference: json["dietaryPreference"],
    goal: json["goal"],
    healthCondition: json["healthCondition"],
    neckSize: json["neckSize"],
    waistSize: json["waistSize"],
    hipSize: json["hipSize"],
    chestSize: json["chestSize"],
    armSize: json["armSize"],
    legSize: json["legSize"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "date": date.toIso8601String(),
    "age": age,
    "weight": weight,
    "height": height,
    "gender": gender,
    "activityLevel": activityLevel,
    "dietaryPreference": dietaryPreference,
    "goal": goal,
    "healthCondition": healthCondition,
    "neckSize": neckSize,
    "waistSize": waistSize,
    "hipSize": hipSize,
    "chestSize": chestSize,
    "armSize": armSize,
    "legSize": legSize,
  };
}
