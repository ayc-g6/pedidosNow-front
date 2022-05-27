class Product {
  String name;
  double price;
  String owner;

  Product({
    required this.name,
    required this.price,
    required this.owner,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      owner: json['owner'],
    );
  }
}
