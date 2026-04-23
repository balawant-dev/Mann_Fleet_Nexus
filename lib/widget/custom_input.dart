import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mannfleet/util/color/app_colors.dart';

enum InputType {
  text,
  number,
  phone,
  dropdown,
  date,
}

class CustomInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final InputType type;
  final List<String>? dropdownItems;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines; // ✅ Added

  const CustomInputBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.type = InputType.text,
    this.dropdownItems,
    this.onChanged,
    this.keyboardType,
    this.onTap,
    this.maxLength,
    this.errorText,
    this.maxLines = 1, // ✅ Default single line
  });

  void _showDropdown(BuildContext context) async {
    if (dropdownItems == null) return;

    final value = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: dropdownItems!.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(dropdownItems![index]),
              onTap: () {
                Navigator.pop(context, dropdownItems![index]);
              },
            );
          },
        );
      },
    );

    if (value != null) {
      controller.text = value;
      if (onChanged != null) onChanged!(value);
    }
  }

  void _showDatePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      controller.text = formattedDate;

      if (onChanged != null) {
        onChanged!(formattedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? formatters;
    TextInputType keyboard = keyboardType ?? TextInputType.text;
    bool readOnly = false;
    IconData? suffixIcon;

    switch (type) {
      case InputType.number:
        keyboard = TextInputType.number;
        formatters = [FilteringTextInputFormatter.digitsOnly];
        break;

      case InputType.phone:
        keyboard = TextInputType.phone;
        formatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
        break;

      case InputType.dropdown:
        readOnly = true;
        suffixIcon = Icons.keyboard_arrow_down;
        break;

      case InputType.date:
        readOnly = true;
        suffixIcon = Icons.calendar_month;
        break;

      case InputType.text:
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: double.infinity,
          // height: MediaQuery.sizeOf(context).height * 0.0625,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: errorText != null
                  ? Colors.red
                  : ColorResource.textColor,
            ),
          ),
          child: TextFormField(
            maxLines: maxLines, // ✅ Applied
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            readOnly: readOnly,
            maxLength: maxLength,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: "",
              border: InputBorder.none,
              // border: InputBorder.none,
              enabledBorder: InputBorder.none,   // ✅ ADD
              focusedBorder: InputBorder.none,   // ✅ ADD
              errorBorder: InputBorder.none,     // ✅ ADD
              disabledBorder: InputBorder.none,  // ✅ ADD
              contentPadding: const EdgeInsets.symmetric(horizontal: 16,  vertical: 14, ),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            ),
            onTap: () {
              if (onTap != null) {
                onTap!(); // ✅ custom onTap first priority
                return;
              }

              if (type == InputType.dropdown) {
                _showDropdown(context);
              } else if (type == InputType.date) {
                _showDatePicker(context);
              }
            },
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ]
      ],
    );
  }
}