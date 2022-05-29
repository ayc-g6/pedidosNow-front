import 'dart:ffi';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.owner,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  String id;
  String name;
  double price;
  String owner;

  // Nutritional facts:
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price.toDouble(),
        'owner': owner,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        owner: json['owner'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
      );
}
