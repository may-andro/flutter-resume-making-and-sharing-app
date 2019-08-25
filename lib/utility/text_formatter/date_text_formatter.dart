import 'package:flutter/services.dart';

class UsDateTextInputFormatter extends TextInputFormatter {
	@override
	TextEditingValue formatEditUpdate(
			TextEditingValue oldValue,
			TextEditingValue newValue,
			) {
		final int newTextLength = newValue.text.length;
		int selectionIndex = newValue.selection.end;
		int usedSubstringIndex = 0;
		final StringBuffer newText = StringBuffer();

		if (newTextLength >= 3) {
			newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
			if (newValue.selection.end >= 2) selectionIndex++;
		}

		if (newTextLength >= 5) {
			newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '/');
			if (newValue.selection.end >= 4) selectionIndex++;
		}

		if (newTextLength >= usedSubstringIndex) {
			newText.write(newValue.text.substring(usedSubstringIndex));
		}

		return TextEditingValue(
			text: newText.toString(),
			selection: TextSelection.collapsed(offset: selectionIndex),
		);
	}
}