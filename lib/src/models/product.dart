import 'dart:ffi';

class Product {
  Product({required this.name, required this.price, required this.owner, required this.id});

  String id;
  String name;
  double price;
  String owner;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        owner: json['owner'],
      );
}
