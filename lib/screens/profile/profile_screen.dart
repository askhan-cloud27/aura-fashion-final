import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favourite_provider.dart';
import '../../services/firestore_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final menuItems = [
      {'icon': Icons.request_page_outlined, 'title': 'Order History', 'route': AppRoutes.orderHistory},
      {'icon': Icons.settings_outlined, 'title': 'Setting', 'route': AppRoutes.settings},
      {'icon': Icons.favorite_border, 'title': 'Favorite', 'route': AppRoutes.favourite},
      {'icon': Icons.person_outline, 'title': 'Account Details', 'route': AppRoutes.accountDetails},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory background matching design
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Avatar
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile/profile .jpeg', // Exact path shown in terminal
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text(
                        'MA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              auth.userName.isNotEmpty ? auth.userName : 'Aura User',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  'Sri Lanka',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ...menuItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ProfileMenuItem(
                      icon: item['icon'] as IconData,
                      title: item['title'] as String,
                      onTap: () => context.push(item['route'] as String),
                    ),
                  )),
                  
                  // Logout
                  _ProfileMenuItem(
                    icon: Icons.person_remove_alt_1_outlined, 
                    title: 'Logout',
                    onTap: () {
                      context.read<FavouriteProvider>().clear();
                      auth.logout();
                      context.go(AppRoutes.onboarding);
                    },
                  ),
                  const Divider(height: 32),
                  // Seed Database (Dev only)
                  _ProfileMenuItem(
                    icon: Icons.storage_outlined,
                    title: 'Seed Database (Admin)',
                    onTap: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      scaffold.showSnackBar(
                        const SnackBar(content: Text('Seeding database...')),
                      );
                      try {
                        await FirestoreService().seedDatabase();
                        scaffold.showSnackBar(
                          const SnackBar(content: Text('Database seeded!')),
                        );
                      } catch (e) {
                        scaffold.showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5D5B5), width: 1.5), // Gold border matching checkout
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold, // Design uses heavily weighted black text
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
