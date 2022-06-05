enum OrderState { unconfirmed, assigned, preparing, delivering, done }

class Order {
  Order({
    required this.id,
    required this.productId,
    required this.businessId,
    required this.customerId,
    required this.quantity,
    required this.state,
    required this.deliveryAddress,
  });

  int id;
  int productId;
  String businessId;
  String customerId;
  String deliveryAddress;
  int quantity;
  OrderState state;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      productId: json['product_id'],
      businessId: json['business_id'],
      customerId: json['customer_id'],
      deliveryAddress: json['delivery_address'],
      quantity: json['quantity'],
      state: OrderState.values[json['state']],
    );
  }

  String get stateName {
    switch (state) {
      case OrderState.unconfirmed:
        return 'Awaiting Confirmation';
      case OrderState.assigned:
        return 'Confirmed';
      case OrderState.preparing:
        return 'Being Prepared';
      case OrderState.delivering:
        return 'On Its Way';
      case OrderState.done:
        return 'Delivered';
    }
  }
}
