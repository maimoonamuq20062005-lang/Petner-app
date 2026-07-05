class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String type;
  final String breed;
  final int ageMonths;
  final String gender;
  final String size;
  final String energyLevel;
  final String dietType;
  final String dietPreference;
  final String socialBehaviour;
  final bool hasPreviousBreeding;
  final String livingEnvironment;
  final String healthStatus;
  final bool isVaccinated;
  final String description;
  final List<String> photoUrls;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final List<String> likedByPetIds;
  final DateTime createdAt;
  final bool isActive;

  const PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.ageMonths,
    required this.gender,
    required this.size,
    required this.energyLevel,
    required this.dietType,
    required this.dietPreference,
    required this.socialBehaviour,
    required this.hasPreviousBreeding,
    required this.livingEnvironment,
    required this.healthStatus,
    required this.isVaccinated,
    required this.description,
    required this.photoUrls,
    this.latitude,
    this.longitude,
    this.locationName,
    this.likedByPetIds = const [],
    required this.createdAt,
    this.isActive = true,
  });

  String get ageDisplay {
    if (ageMonths < 12) return '$ageMonths mo';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    if (months == 0) return '${years}y';
    return '${years}y ${months}mo';
  }

  String get primaryPhoto => photoUrls.isNotEmpty ? photoUrls.first : '';

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Dog',
      breed: map['breed'] ?? '',
      ageMonths: map['ageMonths'] ?? 0,
      gender: map['gender'] ?? 'Male',
      size: map['size'] ?? 'Medium',
      energyLevel: map['energyLevel'] ?? 'Moderate',
      dietType: map['dietType'] ?? 'Omnivore',
      dietPreference: map['dietPreference'] ?? 'Mixed',
      socialBehaviour: map['socialBehaviour'] ?? 'Friendly',
      hasPreviousBreeding: map['hasPreviousBreeding'] ?? false,
      livingEnvironment: map['livingEnvironment'] ?? 'House',
      healthStatus: map['healthStatus'] ?? 'Good',
      isVaccinated: map['isVaccinated'] ?? false,
      description: map['description'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      locationName: map['locationName'],
      likedByPetIds: List<String>.from(map['likedByPetIds'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'ageMonths': ageMonths,
      'gender': gender,
      'size': size,
      'energyLevel': energyLevel,
      'dietType': dietType,
      'dietPreference': dietPreference,
      'socialBehaviour': socialBehaviour,
      'hasPreviousBreeding': hasPreviousBreeding,
      'livingEnvironment': livingEnvironment,
      'healthStatus': healthStatus,
      'isVaccinated': isVaccinated,
      'description': description,
      'photoUrls': photoUrls,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'likedByPetIds': likedByPetIds,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  PetModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? type,
    String? breed,
    int? ageMonths,
    String? gender,
    String? size,
    String? energyLevel,
    String? dietType,
    String? dietPreference,
    String? socialBehaviour,
    bool? hasPreviousBreeding,
    String? livingEnvironment,
    String? healthStatus,
    bool? isVaccinated,
    String? description,
    List<String>? photoUrls,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? likedByPetIds,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return PetModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      ageMonths: ageMonths ?? this.ageMonths,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      energyLevel: energyLevel ?? this.energyLevel,
      dietType: dietType ?? this.dietType,
      dietPreference: dietPreference ?? this.dietPreference,
      socialBehaviour: socialBehaviour ?? this.socialBehaviour,
      hasPreviousBreeding: hasPreviousBreeding ?? this.hasPreviousBreeding,
      livingEnvironment: livingEnvironment ?? this.livingEnvironment,
      healthStatus: healthStatus ?? this.healthStatus,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      description: description ?? this.description,
      photoUrls: photoUrls ?? this.photoUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      likedByPetIds: likedByPetIds ?? this.likedByPetIds,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Sample data for UI preview
class PetSampleData {
  static List<PetModel> get samples => [
    PetModel(
      id: '1',
      ownerId: 'u1',
      name: 'Bella',
      type: 'Dog',
      breed: 'Golden Retriever',
      ageMonths: 24,
      gender: 'Female',
      size: 'Large',
      energyLevel: 'High',
      dietType: 'Omnivore',
      dietPreference: 'Mixed',
      socialBehaviour: 'Playful',
      hasPreviousBreeding: false,
      livingEnvironment: 'House with Yard',
      healthStatus: 'Excellent',
      isVaccinated: true,
      description: 'Bella is a joyful golden girl who loves fetch, cuddles, and making new friends. She is great with kids and other dogs.',
      photoUrls: [
        'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400',
        'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
      ],
      locationName: 'Lahore, Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PetModel(
      id: '2',
      ownerId: 'u2',
      name: 'Max',
      type: 'Dog',
      breed: 'Husky',
      ageMonths: 18,
      gender: 'Male',
      size: 'Large',
      energyLevel: 'High',
      dietType: 'Carnivore',
      dietPreference: 'Homemade',
      socialBehaviour: 'Friendly',
      hasPreviousBreeding: false,
      livingEnvironment: 'House with Yard',
      healthStatus: 'Excellent',
      isVaccinated: true,
      description: 'Max is a beautiful Siberian Husky with bright blue eyes and a gentle soul. He loves running and playing in the snow.',
      photoUrls: [
        'https://images.unsplash.com/photo-1605568427561-40dd23c2acea?w=400',
        'https://images.unsplash.com/photo-1519098901909-b1553a1190af?w=400',
      ],
      locationName: 'Islamabad, Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    PetModel(
      id: '3',
      ownerId: 'u3',
      name: 'Luna',
      type: 'Cat',
      breed: 'Persian',
      ageMonths: 30,
      gender: 'Female',
      size: 'Small',
      energyLevel: 'Low',
      dietType: 'Carnivore',
      dietPreference: 'Processed',
      socialBehaviour: 'Shy',
      hasPreviousBreeding: false,
      livingEnvironment: 'Apartment',
      healthStatus: 'Good',
      isVaccinated: true,
      description: 'Luna is a fluffy Persian princess who loves cozy spots and gentle chin scratches. Perfect for a calm environment.',
      photoUrls: [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
      ],
      locationName: 'Karachi, Pakistan',
      latitude: 24.8607,
      longitude: 67.0011,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    PetModel(
      id: '4',
      ownerId: 'u4',
      name: 'Charlie',
      type: 'Dog',
      breed: 'Beagle',
      ageMonths: 12,
      gender: 'Male',
      size: 'Small',
      energyLevel: 'Moderate',
      dietType: 'Omnivore',
      dietPreference: 'Mixed',
      socialBehaviour: 'Playful',
      hasPreviousBreeding: false,
      livingEnvironment: 'House',
      healthStatus: 'Excellent',
      isVaccinated: true,
      description: 'Charlie is an adventurous beagle puppy with a nose for fun. He loves exploring and meeting new friends.',
      photoUrls: [
        'https://images.unsplash.com/photo-1570824104453-508955ab713e?w=400',
      ],
      locationName: 'Lahore, Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PetModel(
      id: '5',
      ownerId: 'u5',
      name: 'Mochi',
      type: 'Cat',
      breed: 'Bengal',
      ageMonths: 20,
      gender: 'Male',
      size: 'Medium',
      energyLevel: 'High',
      dietType: 'Carnivore',
      dietPreference: 'Homemade',
      socialBehaviour: 'Playful',
      hasPreviousBreeding: false,
      livingEnvironment: 'Apartment',
      healthStatus: 'Excellent',
      isVaccinated: true,
      description: 'Mochi is a wild-at-heart Bengal with stunning rosette spots. He is energetic, curious, and always up for playtime.',
      photoUrls: [
        'https://images.unsplash.com/photo-1548681528-6a5c45b66b42?w=400',
      ],
      locationName: 'Islamabad, Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
