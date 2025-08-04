import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        final user = authProvider.userModel;
        if (user != null) {
          if (user.userType == UserType.client) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.clientDashboard);
          } else if (user.userType == UserType.mover) {
            if (user.verificationStatus == VerificationStatus.pending) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.verificationPending);
            } else if (user.verificationStatus == VerificationStatus.verified) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.moverDashboard);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.moverVerification);
            }
          }
        }
      }
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider.sendPasswordResetEmail(emailController.text.trim());
                
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                        ? 'Password reset email sent successfully!'
                        : 'Failed to send password reset email.'),
                      backgroundColor: success ? AppColors.success : AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.h),
                  
                  // Logo and Title
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_shipping_rounded,
                            size: 40.sp,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Sign in to continue to Dwello',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Login Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButton(
                        text: 'Sign In',
                        onPressed: authProvider.isLoading ? null : _handleLogin,
                        isLoading: authProvider.isLoading,
                      );
                    },
                  ),
                  
                  // Error Message
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.error != null) {
                        return Container(
                          margin: EdgeInsets.only(top: 16.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Text(
                            authProvider.error!,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}