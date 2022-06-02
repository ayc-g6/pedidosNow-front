class Product {
  Product({
    this.id,
    required this.name,
    this.owner,
    required this.price,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  String? id;
  String name;
  String? owner;
  double price;

  // Nutritional facts:
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toDouble(),
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        owner: json['owner'],
        price: json['price'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
      );
}
