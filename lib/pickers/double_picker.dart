import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget for selecting a double value with a slider
class DoublePicker extends StatefulWidget {
  final double initValue; // Initial value of the picker
  final double minValue; // Minimum value that can be selected
  final double maxValue; // Maximum value that can be selected
  final double step; // Step size for the slider
  final void Function(double) setValue; // Callback to update the selected value
  const DoublePicker({
    super.key,
    required this.initValue,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.setValue,
  });

  @override
  State<StatefulWidget> createState() => _DoublePickerState();
}

class _DoublePickerState extends State<DoublePicker> {
  double currentValue = 0; // Current value of the slider

  @override
  void initState() {
    currentValue = widget.initValue; // Set the current value to the initial value
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          currentValue.toStringAsFixed(1), // Display the current value with one decimal place
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Slider(
          value: currentValue, // Set the current value of the slider
          min: widget.minValue, // Set the minimum value of the slider
          max: widget.maxValue, // Set the maximum value of the slider
          divisions: (widget.maxValue - widget.minValue) ~/ widget.step, // Set the number of divisions for the slider
          onChanged: (double value) {
            setState(() {
              currentValue = value; // Update the current value when the slider is moved
            });
            widget.setValue(currentValue); // Call the setValue callback to update the selected value
          },
        ),
      ],
    );
  }
}

// Function to display a double picker dialog and return the chosen value
Future<double> pickDouble(
    BuildContext context,
    double initValue,
    double minValue,
    double maxValue,
    double step,
    ) async {
  double selectedValue = initValue; // Initially set the selected value to the initial value
  double chosenValue = initValue; // Initialize the chosen value to the initial value

  // Show the dialog with the DoublePicker widget inside
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: DoublePicker(
          initValue: initValue,
          minValue: minValue,
          maxValue: maxValue,
          step: step,
          setValue: (double value) {
            selectedValue = value; // Update the selected value from the DoublePicker callback
          },
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without saving changes
            },
            child: Text(
              AppLocalizations.of(context)!.cancel, // Display localized "Cancel" text
            ),
          ),
          ElevatedButton(
            onPressed: () {
              chosenValue = selectedValue; // Save the selected value as the chosen value
              Navigator.pop(context); // Close the dialog and return the chosen value
            },
            child: Text(
              AppLocalizations.of(context)!.confirm, // Display localized "Confirm" text
            ),
          ),
        ],
      );
    },
  );
  return chosenValue; // Return the chosen value after the dialog is closed
}
