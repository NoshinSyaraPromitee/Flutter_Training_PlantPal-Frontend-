class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.lineTotal,
  });

  final String productId, name, imageUrl;
  final int quantity;
  final double lineTotal;

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        productId: (j['productId'] ?? '').toString(),
        name: j['name'] as String? ?? '',
        imageUrl: j['imageUrl'] as String? ?? '',
        quantity: (j['quantity'] as num?)?.toInt() ?? 1,
        lineTotal: (j['lineTotalBdt'] as num?)?.toDouble() ?? 0,
      );
}

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.deliveryTitle,
    required this.deliveryEta,
    required this.paymentMethodId,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  final String id, deliveryTitle, deliveryEta, paymentMethodId, status;
  final List<OrderItem> items;
  final double subtotal, tax, total;
  final DateTime? createdAt;

  factory Order.fromJson(Map<String, dynamic> j) {
    final delivery = j['delivery'] as Map<String, dynamic>? ?? const {};
    return Order(
      id: (j['id'] ?? '').toString(),
      items: [
        for (final i in (j['items'] as List? ?? const []))
          OrderItem.fromJson(i as Map<String, dynamic>),
      ],
      deliveryTitle: delivery['title'] as String? ?? '',
      deliveryEta: delivery['eta'] as String? ?? '',
      paymentMethodId: j['paymentMethodId'] as String? ?? '',
      subtotal: (j['subtotalBdt'] as num?)?.toDouble() ?? 0,
      tax: (j['taxBdt'] as num?)?.toDouble() ?? 0,
      total: (j['totalBdt'] as num?)?.toDouble() ?? 0,
      status: j['status'] as String? ?? '',
      createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '')?.toLocal(),
    );
  }
}
