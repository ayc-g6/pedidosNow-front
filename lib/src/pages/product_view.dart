import 'package:envios_ya/src/services/server.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatefulWidget {
  final int productId;

  const ProductViewPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = Server.getProduct(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Envios Ya"),
        automaticallyImplyLeading: true,
      ),
      body: Card(
        child: Container(
          height: 150,
          color: Colors.white,
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      //TODO change it when list of products is finished
                      child: FutureBuilder<Product>(
                        future: futureProduct,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.name);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        title: Text("Comida Rica",
                            style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Text("De: BurgerPrince"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("\$2500",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ],
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      child: Text("Ver información nutricional"),
                      //TODO: go to te info nutri page
                      onPressed: () => {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        elevation: 8,
        margin: EdgeInsets.all(10),
      ),
    );
  }

/* Usar para llamar esta page
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductViewPage(productId: 3)),
    );
  }, */
}
