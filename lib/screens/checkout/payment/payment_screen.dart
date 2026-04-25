import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../widgets/common/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  final String? address;

  const PaymentScreen({super.key, this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Ivory
      appBar: AppBar(
        title: const Text('Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primary, // Dark Green
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
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
                const SizedBox(height: 16),
                _buildCardField(_cardNumberController, 'Enter Your Card Number'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildCardField(_monthController, 'Month')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCardField(_yearController, 'Year')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 32,
                  child: _buildCardField(_cvvController, 'CVV'),
                ),
                
                const SizedBox(height: 80),

                PrimaryButton(
                  label: 'PROCEED',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.pushReplacement(AppRoutes.orderConfirmation);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5D5B5), width: 1.5), // Light gold border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2), // Solid gold
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
