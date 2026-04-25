import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../widgets/common/primary_button.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final _addressController = TextEditingController();
  final _fixedItemController = TextEditingController(); 
  final _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _fixedItemController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Shipping', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(width: 35, height: 10, child: CustomPaint(painter: DoubleLineArrowPainter())),
                  ),
                  const Text('Payment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accent)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(width: 35, height: 10, child: CustomPaint(painter: DoubleLineArrowPainter())),
                  ),
                  const Text('Review', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address Section
                    const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 16),
                    _buildCheckoutField(_addressController, 'Enter your address'),
                    const SizedBox(height: 16),
                    _buildCheckoutField(_fixedItemController, 'Fixed Item'),
                    const SizedBox(height: 16),
                    _buildCheckoutField(_zipController, 'Zip code'),
                    
                    const SizedBox(height: 32),
                    
                    // Payment Method Section
                    const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildPaymentMethod('assets/images/checkout/images.jpeg'),
                            const SizedBox(width: 8),
                            _buildPaymentMethod('assets/images/checkout/images 1.jpeg'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildPaymentMethod('assets/images/checkout/unnamed.jpeg'),
                            const SizedBox(width: 8),
                            _buildPaymentMethod('assets/images/checkout/images 2.jpeg'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Order Summary Section
                    const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sub Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                        Text('\$${cart.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                        Text('\$${cart.shippingCost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Place Order Button
                    PrimaryButton(
                      label: 'PLACE ORDER',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a Payment Method above to proceed.'),
                              backgroundColor: Colors.black87,
                            ),
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black87, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFF3E2C4), width: 1.5), // Light gold border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildPaymentMethod(String imagePath) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          context.push(AppRoutes.paymentCheckout);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill your shipping address first.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Container(
        width: 75,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain, // Contain ensures logos don't get cropped
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.payment, color: Colors.black26),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_outlined, onTap: () => context.go(AppRoutes.home)),
              _NavItem(icon: Icons.grid_view_outlined, onTap: () => context.go('${AppRoutes.productList}?category=all&title=All Products')),
              _NavItem(icon: Icons.search_outlined, onTap: () {}),
              _NavItem(icon: Icons.person_outline, onTap: () => context.go(AppRoutes.profile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Icon(
          icon,
          color: Colors.black87,
          size: 26,
        ),
      ),
    );
  }
}

class DoubleLineArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width - 6, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width - 6, size.height * 0.7), paint);
    
    final path = Path();
    path.moveTo(size.width - 8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 8, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
