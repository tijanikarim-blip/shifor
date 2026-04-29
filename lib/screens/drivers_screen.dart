import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../widgets/driver_card.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final List<String> _filters = ['All', 'Near Me', 'Top Rated', 'Verified'];
  String _selectedFilter = 'All';
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCountry;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
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
                    'Find Drivers',
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
                      hintText: 'Search drivers...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Country'),
                              isExpanded: true,
                              value: _selectedCountry,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Countries')),
                                ...MockData.countries.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountry = value;
                                  _selectedCity = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_selectedCountry != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('City'),
                                isExpanded: true,
                                value: _selectedCity,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Cities')),
                                  ...(MockData.citiesByCountry[_selectedCountry] ?? [])
                                      .map((c) => DropdownMenuItem(value: c, child: Text(c))),
                                ],
                                onChanged: (value) => setState(() => _selectedCity = value),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedFilter = filter),
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? _buildShimmer()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getFilteredDrivers().length,
                      itemBuilder: (context, index) {
                        final driver = _getFilteredDrivers()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DriverCard(
                            driver: driver,
                            onTap: () => _showDriverDetails(context, driver),
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
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredDrivers() {
    final drivers = _getAllDrivers();
    if (_searchQuery.isEmpty && _selectedFilter == 'All' && _selectedCountry == null && _selectedCity == null) {
      return drivers;
    }
    
    return drivers.where((driver) {
      final matchesSearch = _searchQuery.isEmpty ||
          driver['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Near Me' && driver['location'].toString().contains('Chicago')) ||
          (_selectedFilter == 'Top Rated' && (driver['rating'] as double) >= 4.8) ||
          (_selectedFilter == 'Verified' && driver['verified'] == true);
      final matchesCountry = _selectedCountry == null ||
          driver['location'].toString().contains(_selectedCountry!);
      final matchesCity = _selectedCity == null ||
          driver['location'].toString().contains(_selectedCity!);
      return matchesSearch && matchesFilter && matchesCountry && matchesCity;
    }).toList();
  }

  List<Map<String, dynamic>> _getAllDrivers() {
    return MockData.drivers.map((driver) => {
      'id': driver['id'],
      'name': driver['name'],
      'photo': driver['photo'],
      'rating': driver['rating'],
      'reviews': driver['reviews'],
      'verified': driver['verified'],
      'licenseType': driver['licenseType'],
      'experience': driver['experience'],
      'availability': driver['availability'],
      'location': driver['location'],
      'hourlyRate': driver['hourlyRate'],
    }).toList();
  }

  void _showDriverDetails(BuildContext context, Map<String, dynamic> driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(driver['photo']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            driver['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (driver['verified'] == true) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                color: AppColors.primary, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${driver['rating']} (${driver['reviews']} reviews)'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(Icons.location_on, driver['location']),
            _buildDetailRow(Icons.work, driver['experience']),
            _buildDetailRow(Icons.badge, driver['licenseType']),
            _buildDetailRow(Icons.attach_money, driver['hourlyRate']),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job request sent!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Request Driver',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}