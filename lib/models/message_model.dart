class MessageModel {
  final String id;
  final String matchId;
  final String senderId;
  final String text;
  final String? imageUrl;
  final DateTime sentAt;
  final bool isRead;
  final MessageType type;

  const MessageModel({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.text,
    this.imageUrl,
    required this.sentAt,
    this.isRead = false,
    this.type = MessageType.text,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      matchId: map['matchId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      sentAt: DateTime.tryParse(map['sentAt'] ?? '') ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matchId': matchId,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
      'type': type.name,
    };
  }
}

enum MessageType { text, image, emoji }

class MessageSampleData {
  static List<MessageModel> get samples => [
    MessageModel(
      id: 'msg1',
      matchId: 'm1',
      senderId: 'u2',
      text: "Hey! Our dogs would love to meet 🐾",
      sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    MessageModel(
      id: 'msg2',
      matchId: 'm1',
      senderId: 'u1',
      text: "Aww, definitely! Bella would love playing with Max! 🐶",
      sentAt: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: true,
    ),
    MessageModel(
      id: 'msg3',
      matchId: 'm1',
      senderId: 'u2',
      text: "How about this Saturday at the Lahore Dog Park? 🌿",
      sentAt: DateTime.now().subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
    MessageModel(
      id: 'msg4',
      matchId: 'm1',
      senderId: 'u1',
      text: "Sounds perfect! See you there around noon 😊",
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
    ),
  ];
}
