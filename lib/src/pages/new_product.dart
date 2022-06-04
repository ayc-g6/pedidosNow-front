import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  String? _name;
  String? _description;
  double? _price;

  // Nutritional facts:
  double? _calories;
  double? _protein;
  double? _carbs;
  double? _fat;

  final _createProductFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a product name';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description of the product';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price per unit';
    }
    double price = double.parse(value);
    if (price < 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  String? _validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the calories';
    }
    double calories = double.parse(value);
    if (calories < 0) {
      return 'Please enter a valid amount of calories';
    }
    return null;
  }

  String? _validateCarbs(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the amount of carbohydrates';
    }
    double carbs = double.parse(value);
    if (carbs < 0) {
      return 'Please enter a valid amount of carbs';
    }
    return null;
  }

  String? _validateProtein(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the amount of protein';
    }
    double protein = double.parse(value);
    if (protein < 0) {
      return 'Please enter a valid amount of protein';
    }
    return null;
  }

  String? _validateFat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the amount of fat';
    }
    double fat = double.parse(value);
    if (fat < 0) {
      return 'Please enter a valid amount of fat';
    }
    return null;
  }

  void _createProduct() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    Auth auth = Provider.of<Auth>(context, listen: false);
    if (_createProductFormKey.currentState!.validate()) {
      _createProductFormKey.currentState!.save();
      try {
        await Server.createProduct(auth.accessToken!,
            name: _name!,
            description: _description!,
            price: _price!,
            calories: _calories!,
            protein: _protein!,
            carbs: _carbs!,
            fat: _fat!);
        if (mounted) Navigator.of(context).pop(true);
      } on ServerException catch (e) {
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(e.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Widget _productForm() {
    return Form(
      key: _createProductFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onSaved: (value) => _name = value,
            validator: (value) => _validateName(value),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _description = value,
            validator: (value) => _validateDescription(value),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _price = double.parse(value!),
            validator: (value) => _validatePrice(value),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Price',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _calories = double.parse(value!),
            validator: (value) => _validateCalories(value),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Calories (cal)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _carbs = double.parse(value!),
            validator: (value) => _validateCarbs(value),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Carbohydrates (grams)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _protein = double.parse(value!),
            validator: (value) => _validateProtein(value),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Protein (grams)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _fat = double.parse(value!),
            validator: (value) => _validateFat(value),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fat (grams)',
            ),
          ),
          const SizedBox(height: 16.0),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async => _createProduct(),
                  child: const Text("Create product"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _productForm(),
      ))),
    );
  }
}
