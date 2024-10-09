// To parse this JSON data, do
//
//     final chatUser = chatUserFromJson(jsonString);

import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
    String image;
    String name;
    String about;
    String createdAt;
    String id;
    String lastActive;
    bool isOnline;
    String pushToken;
    String email;

    ChatUser({
        required this.image,
        required this.name,
        required this.about,
        required this.createdAt,
        required this.id,
        required this.lastActive,
        required this.isOnline,
        required this.pushToken,
        required this.email,
    });

    factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        image: json["image"] ?? "",
        name: json["name"] ?? "",
        about: json["about"] ?? "",
        createdAt: json["created_at"] ?? "",
        id: json["id"] ?? "",
        lastActive: json["last_active"] ?? "",
        isOnline: json["is_online"] ?? "",
        pushToken: json["push_token"] ?? "",
        email: json["email"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "about": about,
        "created_at": createdAt,
        "id": id,
        "last_active": lastActive,
        "is_online": isOnline,
        "push_token": pushToken,
        "email": email,
    };
}
