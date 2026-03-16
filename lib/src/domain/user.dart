import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String referralCode;
  final int points;
  final bool isMember;
  final String membershipLevel;

  const UserProfile({
    required this.id,
    required this.name,
    required this.referralCode,
    required this.points,
    required this.isMember,
    this.membershipLevel = 'Guest',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? referralCode,
    int? points,
    bool? isMember,
    String? membershipLevel,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      referralCode: referralCode ?? this.referralCode,
      points: points ?? this.points,
      isMember: isMember ?? this.isMember,
      membershipLevel: membershipLevel ?? this.membershipLevel,
    );
  }

  @override
  List<Object?> get props => [id, name, referralCode, points, isMember, membershipLevel];
}

