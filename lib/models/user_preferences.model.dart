class UserPreferencesRequest {
  final String userId;
  final List<UserPreference> preferences;

  UserPreferencesRequest({
    required this.userId,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userPreferences': preferences.map((p) => p.toJson()).toList(),
    };
  }
}

class UserPreference {
  final String preferenceType;
  final List<String> preferenceValue;

  UserPreference({
    required this.preferenceType,
    required this.preferenceValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferenceType': preferenceType,
      'preferenceValue': preferenceValue,
    };
  }
}

class UserPreferenceResponse {
  final String id;
  final String userId;
  final String preferenceType;
  final List<String> preferenceValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferenceResponse({
    required this.id,
    required this.userId,
    required this.preferenceType,
    required this.preferenceValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferenceResponse.fromJson(Map<String, dynamic> json) {
    return UserPreferenceResponse(
      id: json['id'],
      userId: json['userId'],
      preferenceType: json['preferenceType'],
      preferenceValue: List<String>.from(json['preferenceValue']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'preferenceType': preferenceType,
      'preferenceValue': preferenceValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
