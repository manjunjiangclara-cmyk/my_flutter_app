import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const DatePickerBottomSheet({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  void _handleDone() {
    widget.onDateSelected(_selectedDate);
    Navigator.of(context).pop();
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: AppStrings.selectDate,
      onClose: _handleClose,
      rightActionText: AppStrings.save,
      onRightAction: _handleDone,
      closeButtonIconSize: UIConstants.datePickerCloseButtonIconSize,
      contentPadding: EdgeInsets.zero,
      child: SizedBox(
        height: UIConstants.cupertinoDatePickerHeight,
        child: CupertinoTheme(
          data: CupertinoTheme.of(context),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumDate: DateTime(UIConstants.datePickerFirstYear, 1, 1),
            maximumDate: DateTime.now(), // Prevent future dates
            onDateTimeChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
      ),
    );
  }
}
