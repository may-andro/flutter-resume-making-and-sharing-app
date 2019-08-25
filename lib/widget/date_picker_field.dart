import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  DatePicker({
    this.labelText,
    this.errorText,
    Key key,
    DateTime dateTime,
    @required this.onChanged,
  })  : assert(onChanged != null),
        date = dateTime == null ? DateTime.now() : DateTime(dateTime.year, dateTime.month, dateTime.day),
        super(key: key);

  final String labelText;
  final String errorText;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() => _showDatePicker(context)),
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText, errorText: errorText),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(DateFormat.yMMM().format(date)),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: DateTime.now());

    if (dateTimePicked != null) {
      onChanged(DateTime(dateTimePicked.year, dateTimePicked.month, dateTimePicked.day));
    }
  }
}
