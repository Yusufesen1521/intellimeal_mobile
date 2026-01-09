// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? token;
  User? user;

  UserModel({
    this.token,
    this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  String? id;
  String? name;
  String? surname;
  String? phoneNumber;
  String? email;
  dynamic password;
  String? role;
  bool? verified;
  int? isReceived;
  List<PersonalInfo>? personalInfo;

  User({
    this.id,
    this.name,
    this.surname,
    this.phoneNumber,
    this.email,
    this.password,
    this.role,
    this.verified,
    this.isReceived,
    this.personalInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    surname: json["surname"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    verified: json["verified"],
    isReceived: json["isReceived"],
    personalInfo: json["personalInfo"] == null ? [] : List<PersonalInfo>.from(json["personalInfo"]!.map((x) => PersonalInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "surname": surname,
    "phoneNumber": phoneNumber,
    "email": email,
    "password": password,
    "role": role,
    "verified": verified,
    "isReceived": isReceived,
    "personalInfo": personalInfo == null ? [] : List<dynamic>.from(personalInfo!.map((x) => x.toJson())),
  };
}

class PersonalInfo {
  String? id;
  String? userId;
  DateTime? date;
  int? age;
  double? weight;
  double? targetWeight;
  int? height;
  String? gender;
  String? activityLevel;
  String? dietaryPreference;
  String? goal;
  String? healthCondition;
  int? neckSize;
  int? waistSize;
  int? hipSize;
  int? chestSize;
  int? armSize;
  int? legSize;

  PersonalInfo({
    this.id,
    this.userId,
    this.date,
    this.age,
    this.weight,
    this.targetWeight,
    this.height,
    this.gender,
    this.activityLevel,
    this.dietaryPreference,
    this.goal,
    this.healthCondition,
    this.neckSize,
    this.waistSize,
    this.hipSize,
    this.chestSize,
    this.armSize,
    this.legSize,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    id: json["id"],
    userId: json["userId"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    age: json["age"],
    weight: json["weight"]?.toDouble(),
    targetWeight: json["targetWeight"]?.toDouble(),
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
    "date": date?.toIso8601String(),
    "age": age,
    "weight": weight,
    "targetWeight": targetWeight,
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
