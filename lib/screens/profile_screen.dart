import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mock_data.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        
        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 80, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Please sign in to view profile'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          );
        }

        final String? imageUrl = user.profileImageUrl;
        final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

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
                              child: hasImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(48),
                                      child: Image.network(
                                        imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                                      ),
                                    )
                                  : _buildDefaultAvatar(),
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
                                child: const Icon(Icons.check, size: 14, color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name.isNotEmpty ? user.name : 'User',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.email.isNotEmpty ? user.email : '',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: authProvider.isAvailable 
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                authProvider.isAvailable ? Icons.check_circle : Icons.cancel,
                                color: authProvider.isAvailable ? AppColors.success : AppColors.error,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                authProvider.isAvailable ? 'Available' : 'Unavailable',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: authProvider.isAvailable ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: authProvider.isAvailable 
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            authProvider.isAvailable ? Icons.toggle_on : Icons.toggle_off,
                            color: authProvider.isAvailable ? AppColors.success : AppColors.error,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Availability',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                authProvider.isAvailable ? 'You are available for jobs' : 'Not accepting jobs',
                                style: TextStyle(fontSize: 12, color: authProvider.isAvailable ? AppColors.success : AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: authProvider.isAvailable,
                          onChanged: (_) => authProvider.toggleAvailability(),
                          activeTrackColor: AppColors.success.withValues(alpha: 0.5),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                        ),
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
                        _buildStatRow(Icons.language_outlined, 'Languages', user.languages.isNotEmpty 
                        ? user.languages.map((l) {
                            final flag = MockData.languageFlags[l] ?? '🌐';
                            return '$flag $l';
                          }).join(', ')
                        : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.location_on_outlined, 'Country', user.country?.isNotEmpty == true ? user.country! : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.location_city_outlined, 'City', user.city?.isNotEmpty == true ? user.city! : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.badge_outlined, 'License Type', user.licenseType?.isNotEmpty == true ? user.licenseType! : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.phone_outlined, 'Phone', user.phone.isNotEmpty ? user.phone : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.email_outlined, 'Email', user.email.isNotEmpty ? user.email : 'Not set'),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.work_outline, 'Role', user.role.toUpperCase()),
                        const Divider(height: 24, color: AppColors.divider),
                        _buildStatRow(Icons.calendar_today_outlined, 'Joined', '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.white),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.person_outline, 'Edit Profile', () => _editProfile(context, authProvider)),
                        _buildMenuItem(Icons.settings_outlined, 'Settings', () => _showComingSoon(context, 'Settings')),
                        _buildMenuItem(Icons.help_outline, 'Help & Support', () => _showComingSoon(context, 'Help & Support')),
                        const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                        _buildMenuItem(Icons.logout, 'Logout', () => _logout(context, authProvider), isDestructive: true),
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

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 60, color: AppColors.primary),
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
          child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 2,
          child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
            ),
            Icon(Icons.chevron_right, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    final nameController = TextEditingController(text: user?.name ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    String? selectedCountry = user?.country;
    String? selectedCity = user?.city;
    String? selectedLicenseType = user?.licenseType;
    List<String> selectedLanguages = List<String>.from(user?.languages ?? ['English']);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLicenseType,
                  decoration: InputDecoration(
                    labelText: 'License Type',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: MockData.licenseTypes.map((type) => DropdownMenuItem<String>(value: type, child: Text(type))).toList(),
                  onChanged: (value) => selectedLicenseType = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: MockData.countries.map((country) => DropdownMenuItem<String>(value: country, child: Text(country))).toList(),
                  onChanged: (value) {
                    selectedCountry = value;
                    selectedCity = null;
                    setModalState(() {});
                  },
                ),
                const SizedBox(height: 16),
                if (selectedCountry != null)
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    decoration: InputDecoration(
                      labelText: 'City',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: (MockData.citiesByCountry[selectedCountry] ?? []).map((city) => DropdownMenuItem<String>(value: city, child: Text(city))).toList(),
                    onChanged: (value) => selectedCity = value,
                  ),
                const SizedBox(height: 16),
                const Text('Languages', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MockData.languages.map((lang) {
                    final isSelected = selectedLanguages.contains(lang);
                    final flag = MockData.languageFlags[lang] ?? '🌐';
                    return FilterChip(
                      label: Text('$flag $lang'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          selectedLanguages.add(lang);
                        } else {
                          selectedLanguages.remove(lang);
                        }
                        setModalState(() {});
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    authProvider.updateUserProfile({
                      'name': nameController.text.trim(),
                      'phone': phoneController.text.trim(),
                      'country': selectedCountry,
                      'city': selectedCity,
                      'licenseType': selectedLicenseType,
                      'languages': selectedLanguages,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.success),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!'), backgroundColor: AppColors.primary),
    );
  }

  Future<void> _logout(BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: AppColors.error), child: const Text('Logout')),
        ],
      ),
    );

    if (confirmed == true) {
      await authProvider.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
        );
      }
    }
  }
}