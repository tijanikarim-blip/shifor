import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../widgets/job_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final List<String> _filters = ['All', 'Full-time', 'Part-time', 'Contract'];
  String _selectedFilter = 'All';
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Jobs',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilterBar(
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onFilterSelected: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                ],
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
                      ? const EmptyState(
                          icon: Icons.work_off_outlined,
                          title: 'No Jobs Found',
                          subtitle:
                              'Try adjusting your filters or search criteria',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: MockData.jobs.length,
                          itemBuilder: (context, index) {
                            return JobCard(job: MockData.jobs[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}