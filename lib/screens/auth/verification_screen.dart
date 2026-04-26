import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'profile_completion_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String phone;
  final String role;

  const VerificationScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.phone,
    required this.role,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _emailOtpController = TextEditingController();
  final _phoneOtpController = TextEditingController();
  
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;
  bool _isEmailLoading = false;
  bool _isPhoneLoading = false;
  bool _isEmailOtpSent = false;
  bool _isPhoneOtpSent = false;

  @override
  void dispose() {
    _emailOtpController.dispose();
    _phoneOtpController.dispose();
    super.dispose();
  }

  String _generateOtp() => (Random().nextInt(900000) + 100000).toString();

  Future<void> _sendEmailOtp() async {
    setState(() => _isEmailLoading = true);
    final otp = _generateOtp();
    debugPrint('Email OTP: $otp');
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isEmailLoading = false;
      _isEmailOtpSent = true;
    });
  }

  Future<void> _verifyEmailOtp() async {
    setState(() => _isEmailLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    
    if (_emailOtpController.text.trim().length == 6) {
      final authProvider = context.read<AuthProvider>();
      authProvider.updateUserProfile({'isEmailVerified': true});
      setState(() => _isEmailVerified = true);
    }
    setState(() => _isEmailLoading = false);
  }

  Future<void> _sendPhoneOtp() async {
    setState(() => _isPhoneLoading = true);
    final otp = _generateOtp();
    debugPrint('Phone OTP: $otp');
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isPhoneLoading = false;
      _isPhoneOtpSent = true;
    });
  }

  Future<void> _verifyPhoneOtp() async {
    setState(() => _isPhoneLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    
    if (_phoneOtpController.text.trim().length == 6) {
      final authProvider = context.read<AuthProvider>();
      authProvider.updateUserProfile({'isPhoneVerified': true});
      setState(() => _isPhoneVerified = true);
    }
    setState(() => _isPhoneLoading = false);
  }

  void _checkVerification() {
    if (_isEmailVerified && _isPhoneVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProfileCompletionScreen(
            userId: widget.userId,
            role: widget.role,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Verify Your Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Complete verification to continue', style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            
            _VerificationCard(
              title: 'Email Verification',
              icon: Icons.email,
              isVerified: _isEmailVerified,
              isLoading: _isEmailLoading,
              otpSent: _isEmailOtpSent,
              value: widget.email,
              onSendOtp: _sendEmailOtp,
              onVerifyOtp: _verifyEmailOtp,
              controller: _emailOtpController,
            ),
            
            const SizedBox(height: 16),
            
            _VerificationCard(
              title: 'Phone Verification',
              icon: Icons.phone,
              isVerified: _isPhoneVerified,
              isLoading: _isPhoneLoading,
              otpSent: _isPhoneOtpSent,
              value: widget.phone,
              onSendOtp: _sendPhoneOtp,
              onVerifyOtp: _verifyPhoneOtp,
              controller: _phoneOtpController,
            ),
            
            const SizedBox(height: 32),
            
            if (_isEmailVerified && _isPhoneVerified)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ProfileCompletionScreen(userId: widget.userId, role: widget.role),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue to Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isVerified;
  final bool isLoading;
  final bool otpSent;
  final String value;
  final VoidCallback onSendOtp;
  final VoidCallback onVerifyOtp;
  final TextEditingController controller;

  const _VerificationCard({
    required this.title,
    required this.icon,
    required this.isVerified,
    required this.isLoading,
    required this.otpSent,
    required this.value,
    required this.onSendOtp,
    required this.onVerifyOtp,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isVerified ? Colors.green : Colors.grey[300]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isVerified ? Colors.green : Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              if (isVerified) const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          
          if (isVerified)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text('Verified', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          else if (!otpSent)
            ElevatedButton(
              onPressed: isLoading ? null : onSendOtp,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white),
              child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Send OTP'),
            )
          else
            Column(
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(labelText: 'Enter OTP', hintText: '6-digit code', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), counterText: ''),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : onVerifyOtp,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Verify'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(onPressed: onSendOtp, child: const Text('Resend OTP')),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}