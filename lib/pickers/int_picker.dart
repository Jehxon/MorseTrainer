import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget for selecting an integer value with a slider
class IntPicker extends StatefulWidget {
  final int initValue; // Initial value of the picker
  final int minValue; // Minimum value that can be selected
  final int maxValue; // Maximum value that can be selected
  final int step; // Step size for the slider
  final void Function(int) setValue; // Callback to update the selected value
  const IntPicker({
    super.key,
    required this.initValue,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.setValue,
  });

  @override
  State<StatefulWidget> createState() => _IntPickerState();
}

class _IntPickerState extends State<IntPicker> {
  double currentValue = 0; // Current value of the slider (double for smoother animation)

  @override
  void initState() {
    currentValue = widget.initValue.toDouble(); // Set the current value to the initial value
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${currentValue.toInt()}", // Display the current value as an integer
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Slider(
          value: currentValue, // Set the current value of the slider
          min: widget.minValue.toDouble(), // Set the minimum value of the slider
          max: widget.maxValue.toDouble(), // Set the maximum value of the slider
          divisions: (widget.maxValue - widget.minValue) ~/ widget.step, // Set the number of divisions for the slider
          onChanged: (double value) {
            setState(() {
              currentValue = value; // Update the current value when the slider is moved
            });
            widget.setValue(currentValue.toInt()); // Call the setValue callback to update the selected value
          },
        ),
      ],
    );
  }
}

// Function to display an integer picker dialog and return the chosen value
Future<int> pickInt(
    BuildContext context,
    int initValue,
    int minValue,
    int maxValue,
    int step,
    ) async {
  int selectedValue = initValue; // Initially set the selected value to the initial value
  int chosenValue = initValue; // Initialize the chosen value to the initial value

  // Show the dialog with the IntPicker widget inside
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: IntPicker(
          initValue: initValue,
          minValue: minValue,
          maxValue: maxValue,
          step: step,
          setValue: (int value) {
            selectedValue = value; // Update the selected value from the IntPicker callback
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
