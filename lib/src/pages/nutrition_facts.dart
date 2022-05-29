import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutritionalInfoPage extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final _caloriesColor = Colors.green;
  final _proteinColor = Colors.red;
  final _carbsColor = Colors.blue;
  final _fatColor = Colors.amber;

  const NutritionalInfoPage(
      {Key? key,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritional Information'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            NutritionFact(
                text: "Calories",
                amount: calories,
                unit: "cal",
                circleColor: _caloriesColor),
            NutritionFact(
                text: "Protein",
                amount: protein,
                unit: "g",
                circleColor: _proteinColor),
            NutritionFact(
                text: "Carbohydrates",
                amount: carbs,
                unit: "g",
                circleColor: _carbsColor),
            NutritionFact(
                text: "Fat", amount: fat, unit: "g", circleColor: _fatColor),
            MacronutrientsChart(
              data: [
                MacronutrientsChartData("Protein", protein, _proteinColor),
                MacronutrientsChartData("Carbohydrates", carbs, _carbsColor),
                MacronutrientsChartData("Fat", fat, _fatColor)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionFact extends StatelessWidget {
  final String text;
  final Color circleColor;
  final double amount;
  final String unit;

  const NutritionFact(
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
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
    return SfCircularChart(series: <CircularSeries>[
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
              useSeriesColor: true))
    ]);
  }
}

class MacronutrientsChartData {
  final String name;
  final double amount;
  final Color color;

  MacronutrientsChartData(this.name, this.amount, this.color);
}
