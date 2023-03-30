import 'package:flutter/material.dart';

import '../../database/main.dart';
import '../../models/academic/course.dart';
import '../../themes.dart';
import '../../widgets/card.dart';

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
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 15, top: 20),
                child: SizedBox(
                  height: 45,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final e = days[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: DayButton(
                          onPressed: () => widget.academicService.setDay(e),
                          text: e,
                          isSelected: widget.academicService.day == e,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.academicService.slots!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: 20,
                            left: 20,
                            top: 20,
                            bottom: (index + 1) ==
                                    widget.academicService.slots!.length
                                ? 20
                                : 0),
                        child: SlotCard(
                            slot: widget.academicService.slots![index]),
                      );
                    }),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class SlotCard extends StatelessWidget {
  final SlotModel slot;
  final String? day;
  const SlotCard({Key? key, required this.slot, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xff03A2DC),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
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
                      '${day != null ? "$day: " : ""}${slot.fromTimeStr.toUpperCase()} - ${slot.toTimeStr.toUpperCase()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${slot.slotName.split("/")[0].toUpperCase()} SLOT',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
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
        ),
      ),
    );
  }
}

class DayButton extends StatelessWidget {
  final bool isSelected;
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

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadiusDirectional.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                spreadRadius: 1,
              )
            ]),
        child: SizedBox(
          width: 65,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                text,
                style: TextStyle(
                    color: isSelected == true
                        ? Colors.white
                        : const Color(0xFF505050),
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
