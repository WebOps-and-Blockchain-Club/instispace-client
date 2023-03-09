import 'package:flutter/material.dart';

import '../../database/main.dart';
import '../../models/academic/course.dart';
import '../../themes.dart';

class TimeTableScreen extends StatefulWidget {
  final AcademicService academicService;

  const TimeTableScreen({Key? key, required this.academicService})
      : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final days = ["Mon", "Tue", "Wed", "Thu", "Fri"];

  @override
  Widget build(BuildContext context) {
    return widget.academicService.slots != null
        ? Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days
                      .map((e) => DayButton(
                            onPressed: () => widget.academicService.setDay(e),
                            text: e,
                            isSelected: widget.academicService.day == e,
                          ))
                      .toList(),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.academicService.slots!.length,
                      itemBuilder: (context, index) {
                        return SlotCard(
                            slot: widget.academicService.slots![index]);
                      }),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class SlotCard extends StatelessWidget {
  final SlotModel slot;
  const SlotCard({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 7,
                  spreadRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xff03A2DC),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 7,
                        spreadRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ]),
                // padding: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '${slot.fromTimeStr.toUpperCase()} - ${slot.toTimeStr.toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${slot.slotName.split("/")[0].toUpperCase()} SLOT',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  slot.course != null ? slot.course!.courseCode : "",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff3C3C3C)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  slot.course != null ? slot.course!.courseName : "",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff262626)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          )),
    );
  }
}

class DayButton extends StatelessWidget {
  final bool? isSelected;
  final void Function()? onPressed;
  final String text;
  const DayButton({
    Key? key,
    this.isSelected = false,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isSelected == true
        ? ColorPalette.palette(context).secondary
        : Colors.white;

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 3,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primaryColor),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Proxima Nova',
              color:
                  isSelected == true ? Colors.white : const Color(0xFF505050),
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ));
  }
}
