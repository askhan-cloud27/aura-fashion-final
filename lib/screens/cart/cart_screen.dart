import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_strings.dart';
import '../../widgets/common/primary_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.black12),
                  const SizedBox(height: 16),
                  const Text('Your card is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('Go Home', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text(
                    'Your Card',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = cart.items[i];
                      return Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                item.product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove,
                                          onTap: () => context.read<CartProvider>().decrementQuantity(item.product.id, item.selectedSize),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add,
                                          onTap: () => context.read<CartProvider>().incrementQuantity(item.product.id, item.selectedSize),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '\$${item.product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              _SmallActionButton(label: 'Delete', onTap: () => cart.removeItem(item.product.id, item.selectedSize)),
                                              const SizedBox(width: 6),
                                              _SmallActionButton(label: 'Add', onTap: () {}),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Footer Total
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Card Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      PrimaryButton(
                        label: 'PROCEED TO CONTINUE',
                        onPressed: () => context.push(AppRoutes.shippingCheckout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SmallActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEEE3C6), // Sand/Gold tint
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }
}
