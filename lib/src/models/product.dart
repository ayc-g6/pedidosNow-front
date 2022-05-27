class Product {
  Product({required this.name, required this.price, required this.owner});

  String name;
  double price;
  String owner;

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'],
        price: json['price'],
        owner: json['owner'],
      );
}
