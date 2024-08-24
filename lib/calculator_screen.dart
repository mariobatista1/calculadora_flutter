import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculadora_flutter/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operator = "";
  String number2 = "";

  Widget buttonValue(String value) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: value == "D"
          ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: getBtnColor(value),
                elevation: 10,
              ),
              onPressed: () {
                btnOnTap(value);
              },
              label: const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: getBtnColor(value),
                elevation: 10,
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                btnOnTap(value);
              },
            ),
    );
  }

  Color getBtnColor(value) {
    return [Button.del, Button.clr].contains(value)
        ? Colors.grey
        : [
            Button.per,
            Button.multiply,
            Button.divide,
            Button.subtract,
            Button.add,
            Button.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  void btnOnTap(String value) {
    if (value == Button.del) {
      delete(value);
      return;
    }
    if (value == Button.clr) {
      clearAll();
      return;
    }

    if (value == Button.per) {
      convertToPercentage();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operator.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1.replaceAll(',', '.'));
    final double num2 = double.parse(number2.replaceAll(',', '.'));

    var result = 0.0;

    switch (operator) {
      case Button.add:
        result = num1 + num2;
        break;
      case Button.subtract:
        result = num1 - num2;
        break;
      case Button.multiply:
        result = num1 * num2;
        break;
      case Button.divide:
        result = num1 / num2;
        break;

      default:
    }
    setState(() {
      number1 = '$result';

      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operator = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && number2.isNotEmpty && operator.isNotEmpty) {
      calculate();
    }

    if (operator.isNotEmpty) {
      return;
    }

    final number = double.tryParse(number1);

    if (number == null) {
      return;
    }

    setState(() {
      number1 = "${(number / 100)}";
      operator = "";
      number2 = '';
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operator = "";
      number2 = "";
    });
  }

  void delete(String value) {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Button.dot && int.tryParse(value) == null) {
      if (number1.isEmpty) {
        setState(() {
          number1 = "0";
        });
      }

      if (operator.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operator = value;
    } else if (number1.isEmpty || operator.isEmpty) {
      if (value == Button.dot && number1.contains(Button.dot)) return;

      if (value == Button.dot && (number1.isEmpty || number1 == Button.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operator.isNotEmpty) {
      if (value == Button.dot && number2.contains(Button.dot)) return;

      if (value == Button.dot && (number2.isEmpty || number2 == Button.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: AutoSizeText(
                    '$number1$operator$number2'.isEmpty
                        ? '0'
                        : '$number1$operator$number2',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 80,
                    ),
                    maxLines: 1,
                    maxFontSize: 80,
                    minFontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: Button.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Button.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buttonValue(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
