import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';
part 'user_profile.g.dart';

@HiveType(typeId: 2)
class UserProfile extends Equatable {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final bool isAnonymous;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? lastLogin;

  const UserProfile({
    required this.uid,
    this.email,
    required this.isAnonymous,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'],
      isAnonymous: data['isAnonymous'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null 
          ? (data['lastLogin'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'isAnonymous': isAnonymous,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    };
  }

  UserEntity toEntity() => UserEntity(
    uid: uid,
    email: email,
    isAnonymous: isAnonymous,
    createdAt: createdAt,
    lastLogin: lastLogin,
  );

  UserProfile copyWith({
    String? uid,
    String? email,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserProfile(
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
