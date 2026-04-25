import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_colors.dart';
import '../../widgets/common/primary_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory
      body: Column(
        children: [
          // Dark green top block extending like a large header
          Container(
            height: MediaQuery.of(context).padding.top + 60, // Mimic safe area + extra
            color: AppColors.primary,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Confetti graphic
                    Image.asset(
                      'assets/images/checkout/confetti.png', // Target asset if available
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.celebration,
                          size: 100,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    const Text(
                      'Order\nConfirmation !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 80),
                    
                    PrimaryButton(
                      label: 'THANK YOU',
                      onPressed: () {
                        // Navigate back to home
                        context.go(AppRoutes.home);
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
