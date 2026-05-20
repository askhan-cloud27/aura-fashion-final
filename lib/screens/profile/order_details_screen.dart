import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../utils/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel? order;
  const OrderDetailsScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // If order was not passed (e.g. direct deep link or error), we could show an error,
    // but here we'll assume it's passed or use a fallback if needed.
    if (order == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: Text('Order not found.')),
      );
    }

    final dateStr = DateFormat('MMM dd, yyyy').format(order!.placedAt);

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // General Information
            _buildSectionBox(
              title: 'General Information',
              child: Column(
                children: [
                  _InfoRow(label: 'Order ID :', value: '#${order!.orderId.substring(0, 8).toUpperCase()}'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Date :', value: dateStr),
                  const SizedBox(height: 8),
                  const _InfoRow(label: 'customer:', value: 'Verified User'),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Status:',
                    value: order!.status,
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Product Items
            ...order!.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _buildProductItem(
                    imageUrl: item.product.imageUrl,
                    title: item.product.name,
                    price: '\$${item.product.price.toStringAsFixed(2)}',
                    qty: 'Qty ${item.quantity}',
                  ),
                )),
            
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
                  Text('Address : ${order!.shippingAddress}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Method : Standard Shipping', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Tracking : Pending', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
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
                  _InfoRow(label: 'Payment', value: order!.paymentMethod, isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Subtotal', value: '\$${order!.subtotal.toStringAsFixed(2)}', isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Shipping', value: '\$${order!.shippingCost.toStringAsFixed(2)}', isBoldLabel: true, isBoldValue: true),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Total', value: '\$${order!.total.toStringAsFixed(2)}', isBoldLabel: true, isBoldValue: true),
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
        border: Border.all(color: const Color(0xFFE5D5B5), width: 1.5), // Gold border
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.accent, // Gold color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        qty,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
