import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_strings.dart';
import '../../../widgets/common/aura_logo.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Dark green
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Top Section (Dark Green)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(28, 60, 28, 40),
                            color: AppColors.primary,
                            child: Column(
                              children: [
                                const AuraLogo(fontSize: 28),
                                const SizedBox(height: 16),
                                Text(
                                  AppStrings.createAccount,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.joinAura,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Bottom Section (Ivory)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFAF9F6), // Ivory
                                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                              ),
                              padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _nameController,
                                      label: AppStrings.fullName,
                                      prefixIcon: const Icon(Icons.person_outline),
                                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      controller: _emailController,
                                      label: AppStrings.email,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: const Icon(Icons.email_outlined),
                                      validator: (v) => v!.isEmpty ? 'Email is required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      controller: _passwordController,
                                      label: AppStrings.password,
                                      obscureText: _obscurePassword,
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: GestureDetector(
                                        onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                                        child: Icon(
                                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          size: 20, color: Colors.black54,
                                        ),
                                      ),
                                      validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      controller: _confirmController,
                                      label: AppStrings.confirmPassword,
                                      obscureText: _obscureConfirm,
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: GestureDetector(
                                        onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                        child: Icon(
                                          _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          size: 20, color: Colors.black54,
                                        ),
                                      ),
                                      validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Checkbox(
                                            value: _agreedToTerms,
                                            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                                            activeColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: RichText(
                                            text: const TextSpan(
                                              text: "Agree to ",
                                              style: TextStyle(color: Colors.black87, fontSize: 13),
                                              children: [
                                                TextSpan(
                                                  text: "Terms & Condition",
                                                  style: TextStyle(
                                                    color: AppColors.accent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    PrimaryButton(
                                      label: AppStrings.signUp,
                                      isLoading: _isLoading,
                                      onPressed: _handleSignUp,
                                    ),
                                    const SizedBox(height: 24),
                                    GestureDetector(
                                      onTap: () => context.go(AppRoutes.login),
                                      child: RichText(
                                        text: const TextSpan(
                                          text: "Already have an account ? ",
                                          style: TextStyle(color: Colors.black54, fontSize: 13),
                                          children: [
                                            TextSpan(
                                              text: "Log in",
                                              style: TextStyle(
                                                color: AppColors.accent,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
