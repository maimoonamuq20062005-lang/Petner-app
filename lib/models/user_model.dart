class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String? bio;
  final String? location;
  final String role;
  final List<String> petIds;
  final List<String> matchIds;
  final DateTime createdAt;
  final bool isOnline;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.bio,
    this.location,
    this.role = 'pet_owner',
    this.petIds = const [],
    this.matchIds = const [],
    required this.createdAt,
    this.isOnline = false,
    this.isVerified = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      location: map['location'],
      role: map['role'] ?? 'pet_owner',
      petIds: List<String>.from(map['petIds'] ?? []),
      matchIds: List<String>.from(map['matchIds'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isOnline: map['isOnline'] ?? false,
      isVerified: map['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'bio': bio,
      'location': location,
      'role': role,
      'petIds': petIds,
      'matchIds': matchIds,
      'createdAt': createdAt.toIso8601String(),
      'isOnline': isOnline,
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? bio,
    String? location,
    String? role,
    List<String>? petIds,
    List<String>? matchIds,
    DateTime? createdAt,
    bool? isOnline,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      role: role ?? this.role,
      petIds: petIds ?? this.petIds,
      matchIds: matchIds ?? this.matchIds,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
