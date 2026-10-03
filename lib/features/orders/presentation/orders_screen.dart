import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/riverpod_providers.dart';
import '../../../core/network/failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/order_repository.dart';
import '../domain/model/order_models.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  late Future<List<Order>> _future = _fetch();

  Future<List<Order>> _fetch() =>
      OrderRepository(ref.read(apiClientProvider).dio).getOrders();

  Future<void> _reload() async {
    setState(() => _future = _fetch());
    await _future.catchError((_) => <Order>[]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScreen(
      title: l10n.myOrdersLabel,
      child: FutureBuilder<List<Order>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snap.hasError) {
            return ErrorView(
              message: Failure.from(snap.error!).message,
              onRetry: _reload,
            );
          }
          final orders = snap.data ?? const <Order>[];
          if (orders.isEmpty) {
            return EmptyView(
              icon: Icons.receipt_long_outlined,
              title: l10n.noOrdersTitle,
              subtitle: l10n.noOrdersBody,
            );
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Order order;

  String get _status => order.status.isEmpty
      ? ''
      : order.status[0].toUpperCase() + order.status.substring(1);

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt == null ? '' : shortDate(order.createdAt!);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  date,
                  style: AppTextStyles.inter(14, w: FontWeight.w700),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _status,
                  style: AppTextStyles.inter(
                    12,
                    w: FontWeight.w600,
                    c: AppColors.greenPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity} \u00d7 ${item.name}',
                      style: AppTextStyles.inter(13),
                    ),
                  ),
                  Text(
                    taka(item.lineTotal),
                    style: AppTextStyles.inter(13, c: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          const Divider(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  [order.deliveryTitle, order.deliveryEta]
                      .where((s) => s.isNotEmpty)
                      .join(' \u00b7 '),
                  style: AppTextStyles.inter(12, c: AppColors.textMuted),
                ),
              ),
              Text(
                taka(order.total),
                style: AppTextStyles.inter(
                  15,
                  w: FontWeight.w800,
                  c: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
