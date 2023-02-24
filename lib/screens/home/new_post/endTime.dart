import 'package:client/models/date_time_format.dart';
import 'package:client/themes.dart';
import 'package:flutter/material.dart';

class EndTime extends StatefulWidget {
  final DateTime? endTime;
  final bool edit;
  final Function setEndtime;
  const EndTime(
      {Key? key,
      required this.endTime,
      required this.setEndtime,
      required this.edit})
      : super(key: key);

  @override
  State<EndTime> createState() => _EndTimeState();
}

class _EndTimeState extends State<EndTime> {
  late DateTime endTime;
  late DateTime? date;
  late DateTime? time;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      endTime = widget.endTime ?? DateTime.now().add(const Duration(days: 5));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Your Post will be visible till",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 3),
          Text(
            DateTimeFormatModel(dateTime: endTime).toFormat("MMM dd, yyyy") +
                " " +
                DateTimeFormatModel(dateTime: endTime).toFormat("h:mm a"),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: ColorPalette.palette(context).primary),
          )
        ]),
        if (widget.edit)
          IconButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: endTime,
                      firstDate: endTime,
                      lastDate: endTime.add(const Duration(days: 30 * 5)))
                  .then((value) {
                    if (value != null) {
                      setState(() {
                        date = value;
                      });
                    }
                  })
                  .then((value) => showTimePicker(
                      context: context, initialTime: TimeOfDay.now()))
                  .then((value) {
                    if (value != null) {
                      DateTime _dateTime = DateTime(
                          int.parse(
                              date.toString().split(" ").first.split('-')[0]),
                          int.parse(
                              date.toString().split(" ").first.split('-')[1]),
                          int.parse(
                              date.toString().split(" ").first.split('-')[2]),
                          value.hour,
                          value.minute);
                      setState(() {
                        time = _dateTime;
                      });
                    }

                    setState(() {
                      endTime = time!;
                    });
                  })
                  .then((value) => widget.setEndtime(endTime));
            },
            icon: const Icon(Icons.edit),
            color: ColorPalette.palette(context).secondary,
          )
      ],
    );
  }
}
