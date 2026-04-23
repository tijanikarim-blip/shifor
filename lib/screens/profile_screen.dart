import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../widgets/rating_stars.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = MockData.currentDriver;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl: driver['photo'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      driver['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver['licenseType'],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RatingStars(
                      rating: (driver['rating'] as double),
                      showValue: true,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${driver['reviews']} reviews',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    _buildStatRow(Icons.location_on_outlined, 'Location', driver['location']),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.work_outline, 'Experience', driver['experience']),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.assignment_turned_in_outlined, 'Completed Jobs', '${driver['completedJobs']}'),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.speed_outlined, 'Response Rate', '${driver['responseRate']}'),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.check_circle_outline, 'Accept Rate', '${driver['acceptRate']}'),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.phone_outlined, 'Phone', driver['phone']),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.email_outlined, 'Email', driver['email']),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildStatRow(Icons.calendar_today_outlined, 'Joined', driver['joinedDate']),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.person_outline, 'Edit Profile', () {}),
                    _buildMenuItem(Icons.settings_outlined, 'Settings', () {}),
                    _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(Icons.logout, 'Logout', () {}, isDestructive: true),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive ? AppColors.error : AppColors.textSecondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDestructive ? AppColors.error : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}