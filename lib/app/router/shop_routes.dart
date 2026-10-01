import 'package:go_router/go_router.dart';
import 'package:plantpal/features/cart/presentation/screens/cart_screen.dart';
import 'package:plantpal/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:plantpal/features/checkout/presentation/screens/order_success_screen.dart';
import 'package:plantpal/features/orders/presentation/orders_screen.dart';
import 'package:plantpal/features/payments/presentation/screens/payment_screen.dart';
import 'package:plantpal/features/shop/presentation/screens/product_details_screen.dart';
import 'package:plantpal/features/wishlist/presentation/screens/wishlist_screen.dart';

/// Shop / cart / checkout / payment routes (pushed on top of the tab shell).
final shopRoutes = <RouteBase>[
  GoRoute(
    path: '/shop/product/:id',
    builder: (c, s) => ProductDetailsScreen(productId: s.pathParameters['id']!),
  ),
  GoRoute(path: '/wishlist', builder: (c, s) => const WishlistScreen()),
  GoRoute(path: '/cart', builder: (c, s) => const CartScreen()),
  GoRoute(path: '/orders', builder: (c, s) => const OrdersScreen()),
  GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
  GoRoute(
    path: '/payment',
    builder: (c, s) => PaymentScreen(
      total: double.tryParse(s.uri.queryParameters['total'] ?? '') ?? 0,
      eta: s.uri.queryParameters['eta'] ?? '3-5 Days',
    ),
  ),
  GoRoute(
    path: '/order-success',
    builder: (c, s) => OrderSuccessScreen(
      orderId: s.uri.queryParameters['orderId'] ?? '',
      eta: s.uri.queryParameters['eta'] ?? '3-5 Days',
    ),
  ),
];
