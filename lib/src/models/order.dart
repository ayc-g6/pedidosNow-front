import 'product.dart';

class Order {
  Order({required this.product});

  Product product;

  Map<String, dynamic> toJson() => {
        'product': product,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        product: json['product'],
      );
}
