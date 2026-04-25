import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_strings.dart';
import '../../widgets/common/aura_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const _AppDrawer(),
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xFF0F261D), // Darker green from design
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  centerTitle: true,
                  title: const AuraLogo(
                    fontSize: 26,
                    color: Color(0xFFE5D5B5), // Premium Gold
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white, size: 26),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 26),
                      onPressed: () => context.go(AppRoutes.cart),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Banner
                      _HeroBanner(),
                      const SizedBox(height: 24),

                      // Category chips
                      _CategorySection(),
                      const SizedBox(height: 24),

                      // Looks We Love
                      _SectionHeader(
                        title: AppStrings.looksWeLove,
                        onSeeAll: () => context.go('${AppRoutes.productList}?category=all&title=Looks We Love'),
                      ),
                      const SizedBox(height: 12),
                      _LooksWeLoveList(),
                      const SizedBox(height: 24),

                      // Recommended For You
                      _SectionHeader(
                        title: AppStrings.recommendedForYou,
                        onSeeAll: () => context.go('${AppRoutes.productList}?category=all&title=Recommended'),
                      ),
                      const SizedBox(height: 12),
                      _RecommendedList(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 490,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full background image — covers entire banner
          Image.asset(
            'assets/images/home/Home 1 (1).jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          // Subtle left-side gradient so text remains readable over image
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFF0EDE5).withOpacity(0.88), // beige/cream on left
                  Colors.transparent,                          // transparent on right
                ],
                stops: const [0.0, 0.55],
              ),
            ),
          ),
          // Text content overlaid on the left
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 16, top: 0, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'NEW ARRIVALS :',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Silk  &\nEmerald',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Colors.black,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: const BoxDecoration(
                    color: Color(0xFFBDA882), // warm tan/gold matching design
                  ),
                  child: const Text(
                    'SHOP COLLECTION',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
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

class _CategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'label': 'Woman', 'category': 'womens', 'icon': Icons.woman_outlined},
      {'label': 'Man', 'category': 'mens', 'icon': Icons.man_outlined},
      {'label': 'Accessories', 'category': 'acc', 'icon': Icons.watch_outlined},
      {'label': 'shoes', 'category': 'shoes', 'icon': Icons.shopping_bag_outlined}, // Using shopping bag as a placeholder for a better choice if heel not available
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, i) {
          final cat = categories[i];
          return GestureDetector(
            onTap: () => context.go(
              '${AppRoutes.productList}?category=${cat['category']}&title=${cat['label']}',
            ),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Icon(cat['icon'] as IconData, color: Colors.black, size: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              AppStrings.seeAll,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LooksWeLoveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = [
      const ProductModel(
        id: 'h2',
        name: 'The Boston Tee',
        brand: 'AURA',
        description: 'A cream-colored, drop-shoulder graphic tee featuring "The Boston" in script across the chest and additional block text near the bottom hem. It\'s a classic streetwear staple.',
        price: 180.0,
        imageUrl: 'assets/images/home/home 2.jpg',
        category: ProductCategory.mens,
      ),
      const ProductModel(
        id: 'h4',
        name: 'Printed Set',
        brand: 'AURA',
        description: 'A matching co-ord set featuring a vibrant, artistic print on premium breathable fabric. Perfect for effortless summer elegance.',
        price: 220.0,
        imageUrl: 'assets/images/home/home4.jpg',
        category: ProductCategory.mens,
      ),
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => _LargeProductCard(product: products[i]),
      ),
    );
  }
}

class _RecommendedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = [
      const ProductModel(
        id: 'h5',
        name: 'Linen Comfort',
        brand: 'AURA',
        description: 'Crafted from highest quality European linen, this crisp white shirt offers a relaxed yet sophisticated silhouette for warm evenings.',
        price: 150.0,
        imageUrl: 'assets/images/home/home 5.jpg',
        category: ProductCategory.womens,
      ),
      const ProductModel(
        id: 'h6',
        name: 'Olive Suit',
        brand: 'AURA',
        description: 'A tailored olive green suit made from premium wool blend, featuring a modern slim fit and subtle textured finish for the modern professional.',
        price: 450.0,
        imageUrl: 'assets/images/home/home 6.jpg',
        category: ProductCategory.mens,
      ),
      const ProductModel(
        id: 'h3',
        name: 'Ethnic Elegance',
        brand: 'AURA',
        description: 'This outfit mixes styles by pairing a white off-the-shoulder crop top and denim shorts with a heavily patterned red dupatta draped over one side to mimic a saree\'s flow.',
        price: 600.0,
        imageUrl: 'assets/images/home/home3.jpg',
        category: ProductCategory.womens,
      ),
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => _LargeProductCard(product: products[i]),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.accent,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aura Fashion User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'premium@aurafashion.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.person_outline,
                  label: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.profile);
                  },
                ),
                _DrawerItem(
                  icon: Icons.list_alt_outlined,
                  label: 'Order History',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.orderHistory);
                  },
                ),
                _DrawerItem(
                  icon: Icons.favorite_border,
                  label: 'Wishlist',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.favourite);
                  },
                ),
                const Divider(height: 32, indent: 24, endIndent: 24),
                _DrawerItem(
                  icon: Icons.woman_outlined,
                  label: 'Women\'s Collection',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('${AppRoutes.productList}?category=womens&title=Women\'s Collection');
                  },
                ),
                _DrawerItem(
                  icon: Icons.man_outlined,
                  label: 'Men\'s Collection',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('${AppRoutes.productList}?category=mens&title=Men\'s Collection');
                  },
                ),
                _DrawerItem(
                  icon: Icons.watch_outlined,
                  label: 'Accessories',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('${AppRoutes.productList}?category=acc&title=Accessories');
                  },
                ),
                const Divider(height: 32, indent: 24, endIndent: 24),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.settings);
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline,
                  label: 'Support',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(24),
            child: _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      dense: true,
    );
  }
}

class _LargeProductCard extends StatelessWidget {
  final ProductModel product;
  const _LargeProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail, extra: product),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}



