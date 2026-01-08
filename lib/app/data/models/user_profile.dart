class UserProfile {
  const UserProfile({
    required this.email,
    this.name,
    this.gender,
    this.work,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  final String email;
  final String? name;
  final String? gender;
  final String? work;
  final String? dateOfBirth;
  final double? height;
  final double? weight;

  UserProfile copyWith({
    String? name,
    String? gender,
    String? work,
    String? dateOfBirth,
    double? height,
    double? weight,
  }) {
    return UserProfile(
      email: email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      work: work ?? this.work,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      gender: json['gender']?.toString(),
      work: json['work']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      height: _parseDouble(json['height']),
      weight: _parseDouble(json['weight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (work != null) 'work': work,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
    };
  }
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
