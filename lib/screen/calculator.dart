import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formafit/provider/health_calculator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("حاسبة الصحة"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDropdownSection(context),
                  const SizedBox(height: 20),
                  _buildGenderSection(context),
                  const SizedBox(height: 25),
                  _buildWeightSection(context),
                  const SizedBox(height: 20),
                  _buildHeightSection(context),
                  const SizedBox(height: 20),
                  _buildAgeSection(context),
                  const SizedBox(height: 20),
                  _buildActivityLevelSection(context),
                  const SizedBox(height: 20),
                  _buildCalculateButton(context),
                  const SizedBox(height: 20),
                  _buildResultSection(context),
                  const SizedBox(height: 20),
                  _buildNutrientsChart(context),
                  const SizedBox(height: 20),
                  _buildWeightIndicator(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          const Text("العمليات:", style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Consumer<CalculatorProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedOperation,
                      items: const <String>[
                        CalculatorProvider.operationSelect,
                        CalculatorProvider.operationCalories,
                        CalculatorProvider.operationIdealWeight,
                        CalculatorProvider.operationBMI,
                        CalculatorProvider.operationCaloriesBurned,
                        CalculatorProvider.operationNutrients
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        provider.updateSelectedOperation(newValue!);
                      },
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      dropdownColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGenderOption(context, 'ذكر', 'assets/images/male.png'),
        _buildGenderOption(context, 'أنثى', 'assets/images/female.png'),
      ],
    );
  }

  Widget _buildGenderOption(BuildContext context, String gender, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.amber,
          child: CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        Row(
          children: [
            Text(gender),
            Consumer<CalculatorProvider>(
              builder: (context, provider, child) {
                return Radio<String>(
                  value: gender,
                  groupValue: provider.gender,
                  onChanged: (String? value) {
                    provider.updateGender(value!);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightSection(BuildContext context) {
    return Row(
      children: [
        const Text('الوزن:', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Container(
          width: 50,
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, child) {
              return TextField(
                controller: TextEditingController(text: provider.currentWeight.toStringAsFixed(1)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  provider.updateWeight(double.tryParse(value) ?? provider.currentWeight);
                },
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        const Text('كج'),
        Expanded(
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, child) {
              return Slider(
                value: provider.currentWeight,
                min: 0,
                max: 200,
                divisions: 200,
                label: provider.currentWeight.toStringAsFixed(1),
                onChanged: (double value) {
                  provider.updateWeight(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeightSection(BuildContext context) {
    return Row(
      children: [
        const Text('الطول:', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Container(
          width: 50,
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, child) {
              return TextField(
                controller: TextEditingController(text: provider.currentHeight.toStringAsFixed(1)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  provider.updateHeight(double.tryParse(value) ?? provider.currentHeight);
                },
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        const Text('سم'),
        Expanded(
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, child) {
              return Slider(
                value: provider.currentHeight,
                min: 50,
                max: 250,
                divisions: 200,
                label: provider.currentHeight.toStringAsFixed(1),
                onChanged: (double value) {
                  provider.updateHeight(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgeSection(BuildContext context) {
    return Row(
      children: [
        const Text('العمر:', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Container(
          width: 50,
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, child) {
              return TextFormField(
                controller: TextEditingController(text: provider.currentAge.toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                onChanged: (value) {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue <= 100) {
                    provider.updateAge(newValue);
                  }
                },
              );
            },
          ),
        ),
        const Text("سنة"),
      ],
    );
  }

  Widget _buildActivityLevelSection(BuildContext context) {
    return Row(
      children: [
        const Text("النشاط:", style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
            ),
            child: Consumer<CalculatorProvider>(
              builder: (context, provider, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.activityLevel,
                    items: const <String>[
                      CalculatorProvider.activitySelect,
                      CalculatorProvider.activityNone,
                      CalculatorProvider.activityLight,
                      CalculatorProvider.activityModerate,
                      CalculatorProvider.activityHigh
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      provider.updateActivityLevel(newValue!);
                    },
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    dropdownColor: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<CalculatorProvider>(context, listen: false).calculate();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "احسب",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.showResult,
          child: Column(
            children: [
              const Divider(),
              Text(
                provider.result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutrientsChart(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.showResult && provider.selectedOperation == CalculatorProvider.operationNutrients,
          child: SfCircularChart(
            title: ChartTitle(text: 'نسبة المغذيات'),
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
              PieSeries<NutrientData, String>(
                dataSource: provider.nutrientsData,
                xValueMapper: (NutrientData data, _) => data.nutrient,
                yValueMapper: (NutrientData data, _) => data.percentage,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightIndicator(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.showResult && provider.selectedOperation == CalculatorProvider.operationIdealWeight,
          child: LinearProgressIndicator(
            value: provider.weightIndicatorValue,
            backgroundColor: Colors.grey.shade300,
            color: Colors.amber,
            minHeight: 10,
          ),
        );
      },
    );
  }
}
