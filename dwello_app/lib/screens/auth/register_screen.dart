import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 64,
              color: AppConstants.primaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Register Screen',
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