import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String matchId;
  final String petName;
  final String petImageUrl;

  const ChatScreen({
    super.key,
    required this.matchId,
    required this.petName,
    required this.petImageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<MessageModel> _messages = [...MessageSampleData.samples];
  bool _isTyping = false;
  bool _showTypingIndicator = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(MessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        matchId: widget.matchId,
        senderId: 'demo_user',
        text: text,
        sentAt: DateTime.now(),
        type: MessageType.text,
      ));
      _msgController.clear();
      _showTypingIndicator = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    // Simulate reply
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTypingIndicator = false;
          _messages.add(MessageModel(
            id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
            matchId: widget.matchId,
            senderId: 'other_user',
            text: _getAutoReply(text),
            sentAt: DateTime.now(),
            type: MessageType.text,
          ));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
  }

  String _getAutoReply(String text) {
    final replies = [
      "That sounds amazing! 🐾",
      "Can't wait to meet! 😊",
      "Our pets are going to love each other! 💕",
      "Perfect! Let's plan a playdate 🐕",
      "Aww that's so sweet! 🥰",
    ];
    return replies[DateTime.now().millisecond % replies.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: ClipOval(
                    child: widget.petImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.petImageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.primaryLighter,
                              child: const Icon(Icons.pets,
                                  size: 20, color: AppColors.primary),
                            ),
                          )
                        : Container(
                            color: AppColors.primaryLighter,
                            child: const Icon(Icons.pets,
                                size: 20, color: AppColors.primary),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.online,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.petName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                Text(
                  'Online now',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.online),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red, size: 18),
                    SizedBox(width: 10),
                    Text('Block User'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report_outlined, color: Colors.orange, size: 18),
                    SizedBox(width: 10),
                    Text('Report'),
                  ],
                ),
              ),
            ],
            onSelected: (_) {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_showTypingIndicator ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _showTypingIndicator) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[i];
                final isMe = msg.senderId == 'demo_user';
                return _buildMessageBubble(msg, isMe);
              },
            ),
          ),
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLighter,
              ),
              child: const Center(
                child: Text('🐾', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                        colors: [Color(0xFFFF9DAD), Color(0xFFEC7A92)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isMe ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(msg.sentAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe
                              ? Colors.white70
                              : AppColors.textHint,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLighter,
            ),
            child: const Center(
              child: Text('🐾', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (i * 150)),
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppShadows.nav,
      ),
      child: Row(
        children: [
          // Emoji button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: const Center(
                child: Text('😊', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _msgController,
                onChanged: (v) => setState(() => _isTyping = v.isNotEmpty),
                onSubmitted: (_) => _sendMessage(),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message... 🐾',
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _isTyping
                    ? AppColors.primaryGradient
                    : const LinearGradient(
                        colors: [Color(0xFFE5E7EB), Color(0xFFE5E7EB)]),
                boxShadow: _isTyping ? AppShadows.button : [],
              ),
              child: Icon(
                Icons.send_rounded,
                color: _isTyping ? Colors.white : AppColors.textHint,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }
}
