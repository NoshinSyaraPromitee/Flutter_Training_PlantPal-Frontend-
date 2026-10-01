class PaymentMethod {
  const PaymentMethod(this.id, this.title);
  final String id, title;

  static const all = [
    PaymentMethod('card', 'Credit / Debit Card'),
    PaymentMethod('bkash', 'bKash'),
    PaymentMethod('nagad', 'Nagad'),
    PaymentMethod('cod', 'Cash on Delivery'),
  ];
}

/// One cart line sent to POST /api/v1/orders. Prices are never sent;
/// the backend prices the order from its own catalog.
class OrderLine {
  const OrderLine(this.productId, this.quantity);
  final String productId;
  final int quantity;
}

/// Shipping + delivery choice captured on the checkout screen.
class CheckoutDraft {
  const CheckoutDraft({
    required this.name,
    required this.phone,
    required this.address,
    required this.deliveryOptionId,
  });
  final String name, phone, address, deliveryOptionId;
}

class OrderRequest {
  const OrderRequest({required this.draft, required this.lines});
  final CheckoutDraft draft;
  final List<OrderLine> lines;

  Map<String, dynamic> toJson(String paymentMethodId) => {
        'items': [
          for (final l in lines)
            {'productId': l.productId, 'quantity': l.quantity},
        ],
        'shippingName': draft.name,
        'shippingPhone': draft.phone,
        'shippingAddress': draft.address,
        'deliveryOptionId': draft.deliveryOptionId,
        'paymentMethodId': paymentMethodId,
      };
}

class PaymentResult {
  const PaymentResult({
    required this.success,
    this.orderId = '',
    this.error,
  });
  final bool success;
  final String orderId;

  /// Server or network error message when [success] is false.
  final String? error;
}
