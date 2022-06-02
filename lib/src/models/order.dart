class Order {
  Order({
    this.id,
    required this.productId,
    required this.businessId,
    required this.customerId,
    required this.quantity, 
    required this.state, 
    required this.deliveryAddress
  });

  String? id;
  String? productId;
  String? businessId;
  String? customerId;
  String? deliveryAddress;
  int quantity;
  int state; 

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'business_id': businessId,
        'customer_id': customerId,
        'delivery_address': deliveryAddress,
        'quantity': quantity,
        'state': state,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        productId: json['product_id'],
        businessId: json['business_id'],
        customerId: json['customer_id'],
        deliveryAddress: json['delivery_address'],
        quantity: json['quantity'],
        state: json['state'],
      );
}
