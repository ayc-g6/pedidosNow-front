import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Color palette: https://colorhunt.co/palette/541690ff4949ff8d29ffcd38
const Color caloriesColor = Color.fromRGBO(255, 141, 41, 1);
const Color proteinColor = Color.fromRGBO(84, 22, 144, 1);
const Color carbsColor = Color.fromRGBO(255, 73, 73, 1);
const Color fatColor = Color.fromRGBO(255, 205, 56, 1);

class NutritionFacts extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionFacts({Key? key, required this.calories, required this.protein, required this.carbs, required this.fat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(child: Align(
              child: Container(
                  child: Column(
                    children: [
                       const Text("Nutritional information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 16),
                      NutritionFact(text: "Calories", amount: calories.toStringAsFixed(0), unit: "cal", circleColor: caloriesColor),
                      const SizedBox(height: 8),
                      NutritionFact(text: "Protein", amount: protein.toStringAsFixed(0), unit: "g", circleColor: proteinColor),
                      const SizedBox(height: 8),
                      NutritionFact(text: "Carbohydrates", amount: carbs.toStringAsFixed(0), unit: "g", circleColor: carbsColor),
                      const SizedBox(height: 8),
                      NutritionFact(text: "Fat", amount: fat.toStringAsFixed(0), unit: "g", circleColor: fatColor)
                  ]), 
                  padding: const EdgeInsets.only(left: 16),
                ),
                alignment: Alignment.topLeft
              )
            ),
            Expanded(child: Align(child: Container(
                  child: MacronutrientsChart(data: [
                      MacronutrientsChartData("Protein", protein, proteinColor),
                      MacronutrientsChartData("Carbohydrates", carbs, carbsColor),
                      MacronutrientsChartData("Fat", fat, fatColor)
                    ]
                  ),
                  padding: const EdgeInsets.only(top: 8),
                  height: 136 // TODO: Check if this is OK
                ),
                alignment: Alignment.topCenter
              )
            )
          ]
        ),
      ),
    );
  }
}

class NutritionFact extends StatelessWidget {
  final String text;
  final Color circleColor;
  final String amount;
  final String unit;

  const NutritionFact({Key? key, required this.text, required this.amount, required this.unit, required this.circleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor
          )
        ),
        Expanded(child: 
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: "  " + text + ": "),
                TextSpan(text: amount + " " + unit, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        )
      ]
    );
  }
}

class MacronutrientsChart extends StatelessWidget {
  final List<MacronutrientsChartData> data;

  const MacronutrientsChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    for (MacronutrientsChartData element in data) {
      totalAmount += element.amount;
    }

    return SfCircularChart(
      series: <CircularSeries>[
          DoughnutSeries<MacronutrientsChartData, String>(
              dataSource: data,
              pointColorMapper:(data, _) => data.color,
              xValueMapper: (data, _) => data.name,
              yValueMapper: (data, _) => data.amount,
              dataLabelMapper: (data, _) => (data.amount / totalAmount * 100).toStringAsFixed(1) + "%",
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                useSeriesColor: true
              )
          )
      ]
    );
  }
}

class MacronutrientsChartData {
  final String name;
  final double amount;
  final Color color;

  MacronutrientsChartData(this.name, this.amount, this.color);
}
