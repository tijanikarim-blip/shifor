import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../widgets/message_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isLoading = true;
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEmpty = MockData.messages.isEmpty;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            const SkeletonLoader(
                          width: double.infinity,
                          height: 76,
                        ),
                      )
                    : _isEmpty
                        ? const EmptyState(
                            icon: Icons.chat_bubble_outline,
                            title: 'No Messages',
                            subtitle: 'Start a conversation with companies',
                          )
                        : ListView.separated(
                            itemCount: MockData.messages.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              indent: 80,
                              color: AppColors.divider,
                            ),
                            itemBuilder: (context, index) {
                              return MessageItem(
                                message: MockData.messages[index],
                                onTap: () => _openChat(context, MockData.messages[index]),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(BuildContext context, Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(message['photo']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Online now', style: TextStyle(fontSize: 12, color: AppColors.success)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.info_outline), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['lastMessage']),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message sent!'), backgroundColor: AppColors.success),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}