import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../widgets/common/primary_button.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  final String? address;

  const PaymentScreen({super.key, this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCardComplete = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cartProvider = context.read<CartProvider>();
    
    try {
      // Simulate a network delay for the payment
      await Future.delayed(const Duration(seconds: 2));
      
      // Create the order model
      final order = OrderModel(
        orderId: '', // Will be set by Firestore
        items: cartProvider.items,
        shippingAddress: widget.address ?? 'Standard Shipping',
        paymentMethod: 'Credit Card (Simulated)',
        subtotal: cartProvider.subtotal,
        shippingCost: cartProvider.shippingCost,
        total: cartProvider.total,
        placedAt: DateTime.now(),
      );

      await FirestoreService().placeOrder(order);
      cartProvider.clearCart();
      if (mounted) {
        context.pushReplacement(AppRoutes.orderConfirmation);
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primary, // Dark Green
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                
                // Simulated Card Number Field
                _buildPaymentField(
                  label: 'Card Number',
                  hint: '0000 0000 0000 0000',
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.length < 16) ? 'Enter valid card number' : null,
                ),
                
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildPaymentField(
                        label: 'Expiry Date',
                        hint: 'MM/YY',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.datetime,
                        validator: (value) => (value == null || !value.contains('/')) ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPaymentField(
                        label: 'CVV',
                        hint: '123',
                        icon: Icons.lock_outline,
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.length < 3) ? 'Invalid' : null,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Text(
                  'Note: This is a secure payment simulation for web demo purposes.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                
                const SizedBox(height: 80),

                PrimaryButton(
                  label: 'PAY \$${context.watch<CartProvider>().total.toStringAsFixed(2)}',
                  isLoading: _isLoading,
                  onPressed: _processPayment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentField({
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5D5B5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
