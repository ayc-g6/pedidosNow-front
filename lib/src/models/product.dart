class Product {
  Product({
    required this.id,
    required this.name,
    required this.ownerID,
    required this.price,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  int id;
  String name;
  String ownerID;
  double price;
  // Nutritional Information
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        ownerID: json['owner'],
        price: json['price'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
      );
}
