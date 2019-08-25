import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resumepad/utility/color_utility.dart';

class CustomTextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String helperText;
  final TextInputType textInputType;
  final Function validator;
  final int maxLines;
  final InputBorder inputBorder;
  final List<TextInputFormatter> inputFormatter;
  final int maxLength;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
          fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
          letterSpacing: 1.2),
      decoration: InputDecoration(
        border: inputBorder != null ? inputBorder : InputBorder.none,
        hintText: hintText,
        helperText: helperText,
        counterText: '',
        helperStyle: TextStyle(
            color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
            fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
            letterSpacing: 0.8),
        errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.03, letterSpacing: 0.8),
      ),
      keyboardType: textInputType == null ? TextInputType.text : textInputType,
      controller: controller,
      maxLines: maxLines != null ? maxLines : 1,
      validator: validator,
      inputFormatters: inputFormatter != null ? inputFormatter : [],
      maxLength: maxLength != null ? maxLength : null,
      readOnly: readOnly != null ? readOnly : false,
    );
  }

  CustomTextFieldForm(
      {@required this.controller,
      @required this.helperText,
      @required this.hintText,
      this.textInputType,
      this.validator,
      this.maxLines,
      this.inputBorder,
      this.inputFormatter,
      this.maxLength,
      this.readOnly});
}
