import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
    );
  }
}