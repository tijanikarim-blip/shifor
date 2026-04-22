import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../widgets/application_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
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
                'My Applications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 3,
                      itemBuilder: (context, index) =>
                          const JobCardSkeleton(),
                    )
                  : _isEmpty
                      ? EmptyState(
                          icon: Icons.assignment_outlined,
                          title: 'No Applications',
                          subtitle: 'Start applying to jobs to see them here',
                          buttonText: 'Browse Jobs',
                          onButtonPressed: () {},
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: MockData.applications.length,
                          itemBuilder: (context, index) {
                            return ApplicationCard(
                                application: MockData.applications[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}