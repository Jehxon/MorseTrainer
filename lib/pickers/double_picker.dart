import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoublePicker extends StatefulWidget {
  final double initValue;
  final double minValue;
  final double maxValue;
  final double step;
  final void Function(double) setValue;
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
  double currentValue = 0;

  @override
  void initState() {
    currentValue = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          currentValue.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Slider(
          value: currentValue,
          min: widget.minValue,
          max: widget.maxValue,
          divisions: (widget.maxValue - widget.minValue) ~/ widget.step,
          onChanged: (double value) {
            setState(() {
              currentValue = value;
            });
            widget.setValue(currentValue);
          },
        ),
      ],
    );
  }
}

Future<double> pickDouble(
  BuildContext context,
  double initValue,
  double minValue,
  double maxValue,
  double step,
) async {
  double selectedValue = initValue;
  double chosenValue = initValue;
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
