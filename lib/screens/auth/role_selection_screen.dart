import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.directions_car, size: 60, color: Color(0xFF1E88E5)),
              const SizedBox(height: 24),
              const Text('Select Your Role', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Choose how you want to use the app', style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    _RoleOption(
                      title: 'Driver',
                      description: 'Find driving jobs and opportunities',
                      icon: Icons.drive_eta,
                      color: const Color(0xFF1E88E5),
                      isSelected: _selectedRole == 'driver',
                      onTap: () => setState(() => _selectedRole = 'driver'),
                    ),
                    const SizedBox(height: 16),
                    _RoleOption(
                      title: 'Company',
                      description: 'Hire professional drivers',
                      icon: Icons.business,
                      color: const Color(0xFF43A047),
                      isSelected: _selectedRole == 'company',
                      onTap: () => setState(() => _selectedRole = 'company'),
                    ),
                    const SizedBox(height: 16),
                    _RoleOption(
                      title: 'Recruitment Agency',
                      description: 'Connect drivers with companies',
                      icon: Icons.people,
                      color: const Color(0xFFFB8C00),
                      isSelected: _selectedRole == 'agency',
                      onTap: () => setState(() => _selectedRole = 'agency'),
                    ),
                  ],
                ),
              ),
              if (_selectedRole != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Continue as ${_selectedRole == 'driver' ? 'Driver' : _selectedRole == 'company' ? 'Company' : 'Agency'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 48, color: isSelected ? color : Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.grey[800])),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}