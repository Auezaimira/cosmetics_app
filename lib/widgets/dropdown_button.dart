import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

typedef OnOptionsSelected = void Function(
    List<ValueItem<String>> selectedOptions);

class MyDropDown extends StatefulWidget {
  final List<ValueItem<String>> options;
  final List<String>? initialValues; // параметр для начальных значений
  final bool fullWidth;
  final String label;
  final String? hint;
  final SelectionType selectionType;
  final OnOptionsSelected? onOptionsSelected;

  const MyDropDown(
      {super.key,
      required this.options,
      this.initialValues,
      this.fullWidth = false,
      this.label = '',
      this.selectionType = SelectionType.single,
      this.onOptionsSelected,
      this.hint = ''});

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  late List<ValueItem<String>> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.initialValues != null
        ? widget.options
            .where((option) => widget.initialValues!.contains(option.value))
            .toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown<String>(
      selectedOptions: selectedOptions,
      onOptionSelected: (List<ValueItem<String>> selectedOptions) {
        widget.onOptionsSelected?.call(selectedOptions);
      },
      options: widget.options,
      dropdownHeight: 200,
      dropdownBorderRadius: 14,
      dropdownMargin: 4,
      hintColor: Colors.purple,
      hint: widget.hint ?? "",
      selectionType: widget.selectionType,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      optionTextStyle: const TextStyle(fontSize: 16),
      borderColor: Colors.purple,
      borderWidth: 1,
      selectedOptionIcon: const Icon(Icons.check_circle),
      suffixIcon: const Icon(
        Icons.arrow_drop_down_rounded,
      ),
      clearIcon: const Icon(Icons.close_rounded, size: 14),
    );
  }
}
