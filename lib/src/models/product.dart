class Product {
  Product({required this.name, required this.price, required this.owner, required this.calories, required this.protein, required this.carbs, required this.fat});

  String name;
  double price;
  String owner;

  // Nutritional facts:
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'],
        price: json['price'],
        owner: json['owner'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat']
      );
}
