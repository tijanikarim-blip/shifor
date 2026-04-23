import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/storage_repository.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final String userId;
  final String role;

  const ProfileCompletionScreen({
    super.key,
    required this.userId,
    required this.role,
  });

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final UserRepository _userRepository = UserRepository();
  final StorageRepository _storageRepository = StorageRepository();
  final LocationService _locationService = LocationService();
  final ImagePicker _imagePicker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();

  String? _profileImagePath;
  String? _licenseImagePath;
  final List<File> _attestationFiles = [];
  final List<String> _attestationNames = [];
  final List<String> _selectedLicenses = [];
  final List<String> _selectedLanguages = [];
  String? _currentCity;
  double _progress = 0;
  bool _isLoading = false;
  String? _error;

  static const List<String> _licenseTypes = ['B', 'C', 'D', 'CE'];
  static const List<String> _languageOptions = ['English', 'French', 'Arabic', 'Spanish', 'German'];

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    double progress = 0;
    if (_nameController.text.isNotEmpty) progress += 16;
    if (_selectedLicenses.isNotEmpty) progress += 16;
    if (_selectedLanguages.isNotEmpty) progress += 16;
    if (_profileImagePath != null) progress += 16;
    if (_licenseImagePath != null) progress += 16;
    if (_attestationFiles.isNotEmpty) progress += 20;
    setState(() => _progress = progress);
  }

  Future<File?> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800, imageQuality: 85);
    if (pickedFile != null) {
      setState(() => _profileImagePath = pickedFile.path);
      _updateProgress();
    }
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> _pickLicenseImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 1200, imageQuality: 90);
    if (pickedFile != null) {
      setState(() => _licenseImagePath = pickedFile.path);
      _updateProgress();
    }
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> _pickAttestations() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );
      
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          for (final file in result.files) {
            if (file.path != null) {
              _attestationFiles.add(File(file.path!));
              _attestationNames.add(file.name);
            }
          }
        });
        _updateProgress();
      }
    } catch (e) {
      setState(() => _error = 'Failed to pick files: $e');
    }
  }

  void _removeAttestation(int index) {
    setState(() {
      _attestationFiles.removeAt(index);
      _attestationNames.removeAt(index);
    });
    _updateProgress();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);

    final result = await _locationService.getCurrentLocation();
    if (result.isSuccess) {
      setState(() {
        _currentCity = 'Lat: ${result.data!.latitude.toStringAsFixed(2)}, Lng: ${result.data!.longitude.toStringAsFixed(2)}';
      });
    } else {
      final mockResult = await _locationService.getMockLocation();
      setState(() {
        _currentCity = 'Casablanca, Morocco';
      });
    }
    setState(() => _isLoading = false);
    _updateProgress();
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profileImagePath == null) {
      setState(() => _error = 'Please upload a profile picture');
      return;
    }
    if (_selectedLicenses.isEmpty) {
      setState(() => _error = 'Please select at least one license type');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String? profileUrl;
      String? licenseUrl;
      final List<String> attestationUrls = [];

      if (_profileImagePath != null) {
        profileUrl = await _storageRepository.uploadProfileImage(widget.userId, File(_profileImagePath!));
      }

      if (_licenseImagePath != null) {
        licenseUrl = await _storageRepository.uploadLicenseImage(widget.userId, File(_licenseImagePath!));
      }

      for (int i = 0; i < _attestationFiles.length; i++) {
        final url = await _storageRepository.uploadAttestation(widget.userId, i, _attestationFiles[i]);
        attestationUrls.add(url);
      }

      final driverData = {
        'driverId': widget.userId,
        'licenses': _selectedLicenses,
        'languages': _selectedLanguages,
        'experienceYears': int.tryParse(_experienceController.text) ?? 0,
        'profileImageUrl': profileUrl,
        'licenseImageUrl': licenseUrl,
        'attestationUrls': attestationUrls,
        'location': _currentCity != null ? {'city': _currentCity} : null,
        'isAvailable': false,
        'verificationStatus': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _userRepository.createDriverProfile(widget.userId, driverData);
      await _userRepository.updateUser(widget.userId, {'profileCompleted': true});

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      setState(() => _error = e.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProgressBar(progress: _progress),
              const SizedBox(height: 24),
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                  child: Text(_error!, style: TextStyle(color: Colors.red[700])),
                ),
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildLicenseSection(),
              const SizedBox(height: 24),
              _buildLanguagesSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildAttestationsSection(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _completeProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Complete Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Picture *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickProfileImage,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              image: _profileImagePath != null ? DecorationImage(image: FileImage(File(_profileImagePath!)), fit: BoxFit.cover) : null,
            ),
            child: _profileImagePath == null
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text('Tap to upload', style: TextStyle(color: Colors.grey[600])),
                  ])
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          onChanged: (_) => _updateProgress(),
          decoration: InputDecoration(labelText: 'Full Name', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Years of Experience', prefixIcon: const Icon(Icons.work), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }

  Widget _buildLicenseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Driver License *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickLicenseImage,
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
            child: _licenseImagePath != null
                ? ClipRRect(borderRadius: BorderRadius.circular(11), child: Image.file(File(_licenseImagePath!), fit: BoxFit.cover, width: double.infinity))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.badge, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text('Upload License', style: TextStyle(color: Colors.grey[600])),
                  ]),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Select License Types'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _licenseTypes.map((license) {
            final isSelected = _selectedLicenses.contains(license);
            return FilterChip(
              label: Text(license),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => selected ? _selectedLicenses.add(license) : _selectedLicenses.remove(license));
                _updateProgress();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Languages', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languageOptions.map((language) {
            final isSelected = _selectedLanguages.contains(language);
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => selected ? _selectedLanguages.add(language) : _selectedLanguages.remove(language));
                _updateProgress();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _currentCity == null ? _getLocation : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _currentCity != null ? Colors.green : Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(_currentCity != null ? Icons.location_on : Icons.location_searching, color: _currentCity != null ? Colors.green : Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(child: Text(_currentCity ?? 'Tap to detect location', style: TextStyle(color: _currentCity != null ? Colors.black : Colors.grey[600]))),
                if (_isLoading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttestationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attestations & Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Upload certificates, attestations, or other documents (PDF, DOC, JPG, PNG)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickAttestations,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey[600]),
                const SizedBox(height: 8),
                Text('Tap to add documents', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('PDF, DOC, JPG, PNG allowed', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ),
        if (_attestationFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...List.generate(_attestationFiles.length, (index) {
            final isPdf = _attestationNames[index].toLowerCase().endsWith('.pdf');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(isPdf ? Icons.picture_as_pdf : Icons.description, size: 20, color: Colors.blue[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _attestationNames[index],
                      style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: Colors.blue[700]),
                    onPressed: () => _removeAttestation(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _openAttestation(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open document')),
        );
      }
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profile Completion', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${progress.toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
          ),
        ),
      ],
    );
  }
}