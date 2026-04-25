import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../providers/cart_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final hasItems = !cart.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory background
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 24),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // General Information
            _buildSectionBox(
              title: 'General Information',
              child: Column(
                children: [
                  _InfoRow(label: 'Order ID :', value: '#AURA7858'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Date :', value: 'Nov 12,2026'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'customer:', value: 'Askhan'),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Status:',
                    value: 'Deliverd',
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Product Items (Dynamic or Fallback)
            if (hasItems)
              ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildProductItem(
                      imageUrl: item.product.imageUrl,
                      title: item.product.name,
                      price: '\$${item.product.price.toStringAsFixed(2)}',
                      qty: 'Qty ${item.quantity}',
                    ),
                  )).toList()
            else
              ...[
                _buildProductItem(
                  imageUrl: 'assets/images/order details/cart 2.jpg',
                  title: 'Men Printed shirt',
                  price: '\$275.00',
                  qty: 'Qty 1',
                ),
                const SizedBox(height: 6),
                _buildProductItem(
                  imageUrl: 'assets/images/order details/image 3.jpg',
                  title: 'Trendy Frock',
                  price: '\$410.00',
                  qty: 'Qty 1',
                ),
              ],
            
            const SizedBox(height: 12),
            
            // Shipping & Delivery
            _buildSectionBox(
              title: 'Shipping  & Delivery',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  const Text('Address : 1', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('method :Standart', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('TRacking number : Gold link', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Payment & cost
            _buildSectionBox(
              title: 'Payment & cost',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Cost',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Payment', value: 'Visa******123', isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Subtotal', value: hasItems ? '\$${cart.subtotal.toStringAsFixed(2)}' : '\$885.00', isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Shipping', value: hasItems ? '\$${cart.shippingCost.toStringAsFixed(2)}' : '\$125.00', isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Total', value: hasItems ? '\$${cart.total.toStringAsFixed(2)}' : '\$1000.00', isBoldLabel: true, isBoldValue: true),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionBox({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5D5B5), width: 1.5), // Gold border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Need child to span full width natively for custom layouts
          SizedBox(
            width: double.infinity,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required String imageUrl,
    required String title,
    required String price,
    required String qty,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5D5B5), width: 1.5), // Gold border applied to items too
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Stack(
                children: [
                  // Title
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Price
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.accent, // Gold color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Quantity
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      qty,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final bool isBoldLabel;
  final bool isBoldValue;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.isBoldLabel = true,
    this.isBoldValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold || isBoldValue ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
