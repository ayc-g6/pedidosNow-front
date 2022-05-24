class Product {
  String name;
  double price;
  String owner;

  Product(this.name, this.price, this.owner);

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
      };
}
