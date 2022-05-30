import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  String? _name;
  double? _price;
  String? _owner;

  // Nutritional facts:
  double? _calories;
  double? _protein;
  double? _carbs;
  double? _fat;

  final _createProductFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _productForm(),
      ))),
    );
  }

  Widget _productForm() {
    return Form(
      key: _createProductFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onSaved: (value) => _name = value,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _price = double.parse(value!),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Price',
            ),
          ),
          const SizedBox(height: 16.0),
          // TODO: Don't know why this is here, should be automatically
          // TODO: Santi adhiere... deber{ia ser automático
          TextFormField(
            onSaved: (value) => _owner = value,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Owner',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _calories = double.parse(value!),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Calories (cal)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _protein = double.parse(value!),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Protein (grams)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _carbs = double.parse(value!),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Carbohydrates (grams)',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onSaved: (value) => _fat = double.parse(value!),
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
                  child: const Text("Crear producto"))
        ],
      ),
    );
  }

  void _createProduct() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_createProductFormKey.currentState!.validate()) {
      _createProductFormKey.currentState!.save();
      try {
        await Server.createProduct(Product(
            name: _name!,
            price: _price!,
            owner: _owner!,
            calories: _calories!,
            protein: _protein!,
            carbs: _carbs!,
            fat: _fat!));
      } on ServerException catch (e) {
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(e.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
