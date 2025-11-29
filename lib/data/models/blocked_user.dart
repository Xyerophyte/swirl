import 'user.dart';

/// Blocked User Model
/// Represents a user that has been blocked by the current user
class BlockedUser {
  final String id;
  final String userId;
  final String blockedUserId;
  final String? reason;
  final DateTime createdAt;

  // Optional: Include the blocked user's profile data for display
  final User? blockedUserProfile;

  const BlockedUser({
    required this.id,
    required this.userId,
    required this.blockedUserId,
    this.reason,
    required this.createdAt,
    this.blockedUserProfile,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      blockedUserId: json['blocked_user_id'] as String,
      reason: json['reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      blockedUserProfile: json['blocked_user_profile'] != null
          ? User.fromJson(json['blocked_user_profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'blocked_user_id': blockedUserId,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy with method for immutability
  BlockedUser copyWith({
    String? id,
    String? userId,
    String? blockedUserId,
    String? reason,
    DateTime? createdAt,
    User? blockedUserProfile,
  }) {
    return BlockedUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      blockedUserId: blockedUserId ?? this.blockedUserId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      blockedUserProfile: blockedUserProfile ?? this.blockedUserProfile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlockedUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BlockedUser(id: $id, blockedUserId: $blockedUserId)';
}