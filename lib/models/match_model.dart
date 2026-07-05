import 'pet_model.dart';

class MatchModel {
  final String id;
  final String pet1Id;
  final String pet2Id;
  final String owner1Id;
  final String owner2Id;
  final DateTime matchedAt;
  final bool isActive;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const MatchModel({
    required this.id,
    required this.pet1Id,
    required this.pet2Id,
    required this.owner1Id,
    required this.owner2Id,
    required this.matchedAt,
    this.isActive = true,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] ?? '',
      pet1Id: map['pet1Id'] ?? '',
      pet2Id: map['pet2Id'] ?? '',
      owner1Id: map['owner1Id'] ?? '',
      owner2Id: map['owner2Id'] ?? '',
      matchedAt: DateTime.tryParse(map['matchedAt'] ?? '') ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      lastMessage: map['lastMessage'],
      lastMessageAt: map['lastMessageAt'] != null
          ? DateTime.tryParse(map['lastMessageAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet1Id': pet1Id,
      'pet2Id': pet2Id,
      'owner1Id': owner1Id,
      'owner2Id': owner2Id,
      'matchedAt': matchedAt.toIso8601String(),
      'isActive': isActive,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
    };
  }
}

class MatchWithPets {
  final MatchModel match;
  final PetModel myPet;
  final PetModel otherPet;

  const MatchWithPets({
    required this.match,
    required this.myPet,
    required this.otherPet,
  });
}

class MatchSampleData {
  static List<MatchWithPets> get samples {
    final pets = PetSampleData.samples;
    return [
      MatchWithPets(
        match: MatchModel(
          id: 'm1',
          pet1Id: '1',
          pet2Id: '2',
          owner1Id: 'u1',
          owner2Id: 'u2',
          matchedAt: DateTime.now().subtract(const Duration(hours: 2)),
          lastMessage: "Hey! Our dogs would love to meet 🐾",
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        myPet: pets[0],
        otherPet: pets[1],
      ),
      MatchWithPets(
        match: MatchModel(
          id: 'm2',
          pet1Id: '3',
          pet2Id: '4',
          owner1Id: 'u3',
          owner2Id: 'u4',
          matchedAt: DateTime.now().subtract(const Duration(days: 1)),
          lastMessage: "Luna said hi to Charlie! 😻",
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        myPet: pets[2],
        otherPet: pets[3],
      ),
    ];
  }
}
