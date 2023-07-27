import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntPicker extends StatefulWidget {
  final int initValue;
  final int minValue;
  final int maxValue;
  final int step;
  final void Function(int) setValue;
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
  double currentValue = 0;

  @override
  void initState() {
    currentValue = widget.initValue.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${currentValue.toInt()}",
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Slider(
          value: currentValue,
          min: widget.minValue.toDouble(),
          max: widget.maxValue.toDouble(),
          divisions: (widget.maxValue - widget.minValue) ~/ widget.step,
          onChanged: (double value) {
            setState(() {
              currentValue = value;
            });
            widget.setValue(currentValue.toInt());
          },
        ),
      ],
    );
  }
}

Future<int> pickInt(
  BuildContext context,
  int initValue,
  int minValue,
  int maxValue,
  int step,
) async {
  int selectedValue = initValue;
  int chosenValue = initValue;
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
            selectedValue = value;
          },
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              chosenValue = selectedValue;
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
            ),
          ),
        ],
      );
    },
  );
  return chosenValue;
}
