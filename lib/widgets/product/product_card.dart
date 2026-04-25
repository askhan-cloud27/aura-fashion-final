import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';


import '../../providers/favourite_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? width;

  const ProductCard({super.key, required this.product, this.width});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavouriteProvider>();
    final isFav = favProvider.isFavourite(product.id);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail, extra: product),
      child: Container(
        width: width ?? 180,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center align for the design
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.broken_image_outlined, color: AppColors.textHint),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => context.read<FavouriteProvider>().toggle(product),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav ? AppColors.error : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent, // Gold
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
