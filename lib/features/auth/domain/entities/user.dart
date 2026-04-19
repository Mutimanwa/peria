import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const UserEntity({
    required this.uid,
    this.email,
    required this.isAnonymous,
    required this.createdAt,
    this.lastLogin,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [uid, email, isAnonymous, createdAt, lastLogin];
}
