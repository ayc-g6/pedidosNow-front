import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;

  const ProductViewPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envios Ya"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Card(
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      minVerticalPadding: 4.0,
                      title: Text(widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Text("De: ${widget.product.owner}"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                        child: const Text("Pedir Producto"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderSummaryPage(product: widget.product),
                            ),
                          );
                        },
                      ))
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "\$${widget.product.price}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ))),
              NutritionalInfo(
                  calories: widget.product.calories,
                  protein: widget.product.protein,
                  carbs: widget.product.carbs,
                  fat: widget.product.fat)
            ]),
            elevation: 8.0,
            margin: const EdgeInsets.all(16.0)),
      ),
    );
  }
}

class NutritionalInfo extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final _caloriesColor = Colors.green;
  final _proteinColor = Colors.red;
  final _carbsColor = Colors.blue;
  final _fatColor = Colors.amber;

  const NutritionalInfo(
      {Key? key,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        NutritionalFact(
            text: "Calories",
            amount: calories,
            unit: "cal",
            circleColor: _caloriesColor),
        NutritionalFact(
            text: "Protein",
            amount: protein,
            unit: "g",
            circleColor: _proteinColor),
        NutritionalFact(
            text: "Carbohydrates",
            amount: carbs,
            unit: "g",
            circleColor: _carbsColor),
        NutritionalFact(
            text: "Fat", amount: fat, unit: "g", circleColor: _fatColor),
        MacronutrientsChart(
          data: [
            MacronutrientsChartData("Protein", protein, _proteinColor),
            MacronutrientsChartData("Carbohydrates", carbs, _carbsColor),
            MacronutrientsChartData("Fat", fat, _fatColor)
          ],
        ),
      ],
    );
  }
}

class NutritionalFact extends StatelessWidget {
  final String text;
  final Color circleColor;
  final double amount;
  final String unit;

  const NutritionalFact(
      {Key? key,
      required this.text,
      required this.amount,
      required this.unit,
      required this.circleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Icon(Icons.circle, color: circleColor),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.subtitle1,
            children: <TextSpan>[
              TextSpan(text: "$text: "),
              TextSpan(
                text: "$amount $unit",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MacronutrientsChart extends StatelessWidget {
  final List<MacronutrientsChartData> data;
  late double _totalAmount;

  MacronutrientsChart({Key? key, required this.data}) : super(key: key) {
    _totalAmount = 0;
    for (MacronutrientsChartData element in data) {
      _totalAmount += element.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<MacronutrientsChartData, String>(
          dataSource: data,
          pointColorMapper: (data, _) => data.color,
          xValueMapper: (data, _) => data.name,
          yValueMapper: (data, _) => data.amount,
          dataLabelMapper: (data, _) =>
              (data.amount / _totalAmount * 100).toStringAsFixed(1) + "%",
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true),
        )
      ],
    );
  }
}

class MacronutrientsChartData {
  final String name;
  final double amount;
  final Color color;

  MacronutrientsChartData(this.name, this.amount, this.color);
}
