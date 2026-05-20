import 'package:go_router/go_router.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/signup/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/product_list/product_list_screen.dart';
import '../screens/product_detail/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/shipping/shipping_screen.dart';
import '../screens/checkout/payment/payment_screen.dart';
import '../screens/order_confirmation/order_confirmation_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/order_history_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/favourite_screen.dart';
import '../screens/profile/order_details_screen.dart';
import '../screens/profile/account_details_screen.dart';
import '../widgets/common/main_scaffold.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String productList = '/product-list';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String shippingCheckout = '/checkout/shipping';
  static const String paymentCheckout = '/checkout/payment';
  static const String orderConfirmation = '/order-confirmation';
  static const String profile = '/profile';
  static const String orderHistory = '/profile/order-history';
  static const String orderDetails = '/profile/order-details';
  static const String settings = '/profile/settings';
  static const String favourite = '/profile/favourite';
  static const String accountDetails = '/profile/account-details';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.productList,
          builder: (context, state) {
            final category = state.uri.queryParameters['category'] ?? 'all';
            final title = state.uri.queryParameters['title'] ?? 'Products';
            final focusSearch = state.uri.queryParameters['search'] == 'true';
            return ProductListScreen(
              category: category, 
              title: title, 
              autoFocusSearch: focusSearch,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.productDetail,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.shippingCheckout,
      builder: (context, state) => const ShippingScreen(),
    ),
    GoRoute(
      path: AppRoutes.paymentCheckout,
      builder: (context, state) {
        final address = state.extra as String? ?? '';
        return PaymentScreen(address: address);
      },
    ),
    GoRoute(
      path: AppRoutes.orderConfirmation,
      builder: (context, state) => const OrderConfirmationScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderHistory,
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        final order = state.extra as OrderModel?;
        return OrderDetailsScreen(order: order);
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.favourite,
      builder: (context, state) => const FavouriteScreen(),
    ),
    GoRoute(
      path: AppRoutes.accountDetails,
      builder: (context, state) => const AccountDetailsScreen(),
    ),
  ],
);
