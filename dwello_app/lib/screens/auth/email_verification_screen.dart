import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_read,
              size: 64,
              color: AppConstants.primaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Email Verification Screen',
              style: AppConstants.headingStyle,
            ),
            SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Coming soon...',
              style: AppConstants.captionStyle,
            ),
          ],
        ),
      ),
    );
  }
}