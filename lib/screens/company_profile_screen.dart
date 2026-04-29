import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/company_provider.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/company_post_jobs_screen.dart';
import '../../screens/company_dashboard_screen.dart';
import '../../screens/company_applicants_screen.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, _) {
        if (!companyProvider.isAuthenticated) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business, size: 80, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Please sign in as company'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                    child: const Text('Sign In as Company'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(color: AppColors.white),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.business, size: 50, color: AppColors.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(companyProvider.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Verified Company', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 12),
                        Text(companyProvider.email, style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: AppColors.white),
                    child: Column(
                      children: [
                        _buildStatRow(Icons.business, 'Industry', companyProvider.industry),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.people, 'Company Size', companyProvider.companySize),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.location_on, 'Location', companyProvider.location),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.phone, 'Phone', companyProvider.phone.isNotEmpty ? companyProvider.phone : 'Not set'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.white),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.dashboard, 'Dashboard', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanyDashboardScreen()))),
                        _buildMenuItem(Icons.people, 'Applicants', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplicantsScreen()))),
                        _buildMenuItem(Icons.post_add, 'Post Jobs', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostJobsScreen()))),
                        _buildMenuItem(Icons.settings, 'Settings', () {}),
                        const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                        _buildMenuItem(Icons.logout, 'Logout', () => _logout(context, companyProvider), isDestructive: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
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
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary))),
        Expanded(
          flex: 2,
          child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
            Icon(icon, size: 22, color: isDestructive ? AppColors.error : AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDestructive ? AppColors.error : AppColors.textPrimary))),
            Icon(Icons.chevron_right, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context, CompanyProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed == true) {
      provider.signOut();
    }
  }
}