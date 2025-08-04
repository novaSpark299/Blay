import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Dashboard'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: 64,
              color: AppConstants.primaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Client Dashboard Screen',
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