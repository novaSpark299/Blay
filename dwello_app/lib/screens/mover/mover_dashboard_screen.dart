import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class MoverDashboardScreen extends StatefulWidget {
  const MoverDashboardScreen({super.key});

  @override
  State<MoverDashboardScreen> createState() => _MoverDashboardScreenState();
}

class _MoverDashboardScreenState extends State<MoverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mover Dashboard'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 64,
              color: AppConstants.primaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Mover Dashboard Screen',
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