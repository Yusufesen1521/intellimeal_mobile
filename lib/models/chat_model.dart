// To parse this JSON data, do
//
//     final chatResponse = chatResponseFromJson(jsonString);

import 'dart:convert';

ChatResponse chatResponseFromJson(String str) => ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  String? response;
  String? categoryDetected;

  ChatResponse({
    this.response,
    this.categoryDetected,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
    response: json["response"],
    categoryDetected: json["category_detected"],
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "category_detected": categoryDetected,
  };
}
