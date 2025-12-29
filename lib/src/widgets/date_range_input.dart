import 'package:flutter/material.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/utils.dart';
import 'package:get/get.dart';

/// A full-width widget for user select date range. Used on filter page such as [ReleaseEventSearchFilterPage].
class DateRangeInput extends StatefulWidget {
  final DateTime? fromDateValue;

  final DateTime? toDateValue;

  final ValueChanged<DateTime?> onFromDateChanged;

  final ValueChanged<DateTime?> onToDateChanged;

  const DateRangeInput(
      {super.key, required this.onFromDateChanged,
      required this.onToDateChanged,
      this.fromDateValue,
      this.toDateValue});

  @override
  _DateRangeInputState createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
  DateTime? fromDate;

  DateTime? toDate;

  @override
  void initState() {
    fromDate = widget.fromDateValue;
    toDate = widget.toDateValue;
    super.initState();
  }

  void _updateFromDate(DateTime? value) {
    if (value != null) {
      setState(() => fromDate = value);
      widget.onFromDateChanged(value);
    }
  }

  void _updateToDate(DateTime? value) {
    if (value != null) {
      setState(() => toDate = value);
      widget.onToDateChanged(value);
    }
  }

  void _onPressFromDate() {
    showDatePicker(
            context: context,
            initialDate: (fromDate == null) ? DateTime.now() : fromDate!,
            firstDate: DateTime(2005),
            lastDate: DateTime(2030))
        .then(_updateFromDate);
  }

  void _onPressToDate() {
    showDatePicker(
            context: context,
            initialDate: (toDate == null) ? DateTime.now() : toDate!,
            firstDate: DateTime(2005),
            lastDate: DateTime(2030))
        .then((_updateToDate));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text('date'.tr),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      icon: Icon(Icons.calendar_today),
                      label: Text((fromDate == null)
                          ? 'from'.tr
                          : DateTimeUtils.toSimpleFormat(fromDate)),
                      onPressed: _onPressFromDate),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('-'),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      icon: Icon(Icons.calendar_today),
                      label: Text((toDate == null)
                          ? 'to'.tr
                          : DateTimeUtils.toSimpleFormat(toDate)),
                      onPressed: _onPressToDate),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
