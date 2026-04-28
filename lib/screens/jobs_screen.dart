import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/job_card.dart';
import '../widgets/filter_bar.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final List<String> _filters = ['All', 'Full-time', 'Part-time', 'Contract'];
  String _selectedFilter = 'All';
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
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
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterBar(
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? _buildShimmer()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getFilteredJobs().length,
                      itemBuilder: (context, index) {
                        final job = _getFilteredJobs()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JobCard(
                            job: job,
                            onTap: () => _showJobDetails(context, job),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    final jobs = _getAllJobs();
    if (_searchQuery.isEmpty && _selectedFilter == 'All') return jobs;
    
    return jobs.where((job) {
      final matchesSearch = _searchQuery.isEmpty ||
          job['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job['company'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || job['type'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<Map<String, dynamic>> _getAllJobs() {
    return [
      {
        'id': '1',
        'title': 'Long Distance Driver',
        'company': 'Fast Transport Co.',
        'location': 'Paris, France',
        'salary': '€3,500 - €4,500/month',
        'type': 'Full-time',
        'requirements': ['CDL License', '3+ years experience'],
        'posted': '2 hours ago',
        'isUrgent': true,
      },
      {
        'id': '2',
        'title': 'Delivery Driver',
        'company': 'QuickDeliver',
        'location': 'Lyon, France',
        'salary': '€2,800 - €3,200/month',
        'type': 'Part-time',
        'requirements': ['Valid License', 'Own vehicle'],
        'posted': '5 hours ago',
        'isUrgent': false,
      },
      {
        'id': '3',
        'title': 'Truck Driver',
        'company': 'MegaLogistics',
        'location': 'Marseille, France',
        'salary': '€4,000 - €5,000/month',
        'type': 'Full-time',
        'requirements': ['CDL-A', '5+ years experience'],
        'posted': '1 day ago',
        'isUrgent': false,
      },
      {
        'id': '4',
        'title': 'Local Delivery Driver',
        'company': 'CityExpress',
        'location': 'Toulouse, France',
        'salary': '€2,500 - €3,000/month',
        'type': 'Contract',
        'requirements': ['B License', '1+ year experience'],
        'posted': '3 hours ago',
        'isUrgent': true,
      },
      {
        'id': '5',
        'title': 'Bus Driver',
        'company': 'TransCity',
        'location': 'Nice, France',
        'salary': '€3,200 - €3,800/month',
        'type': 'Full-time',
        'requirements': ['CDL-B', 'Passenger transport license'],
        'posted': '1 day ago',
        'isUrgent': false,
      },
    ];
  }

  void _showJobDetails(BuildContext context, Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job['title'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job['company'],
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.location_on, job['location']),
            _buildDetailRow(Icons.attach_money, job['salary']),
            _buildDetailRow(Icons.work, job['type']),
            _buildDetailRow(Icons.access_time, 'Posted ${job["posted"]}'),
            const SizedBox(height: 20),
            const Text('Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(
              (job['requirements'] as List).length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(job['requirements'][i]),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Application submitted!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}