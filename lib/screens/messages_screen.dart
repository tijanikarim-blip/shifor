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
          _isEmpty = false;
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
                                  message: MockData.messages[index]);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}