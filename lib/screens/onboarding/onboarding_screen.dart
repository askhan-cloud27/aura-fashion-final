import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/aura_logo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Top Brand Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            color: AppColors.primary,
            child: const Center(
              child: AuraLogo(fontSize: 28),
            ),
          ),
          // Hero Image and Content
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Onboarding image
                Image.asset(
                  'assets/images/onboarding/onboard.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                // Dark gradient overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Bottom content — text + button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            AppStrings.onboardTitle,
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 44,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            AppStrings.onboardSubtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFCCCCCC),
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // GET STARTED button
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              color: AppColors.accent,
                              alignment: Alignment.center,
                              child: const Text(
                                AppStrings.getStarted,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
