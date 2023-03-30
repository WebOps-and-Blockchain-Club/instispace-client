import 'package:flutter/material.dart';

import '../../themes.dart';
import '/models/academic/course.dart';
import 'search_course.dart';
import '../../database/config.dart';
import '../../database/main.dart';
import '../../widgets/button/elevated_button.dart';

class AddCourseScreenWrapper extends StatefulWidget {
  final AcademicService academicService;
  final CourseModel? course;
  final String? courseId;
  const AddCourseScreenWrapper(
      {Key? key, required this.academicService, this.course, this.courseId})
      : super(key: key);

  @override
  State<AddCourseScreenWrapper> createState() => _AddCourseScreenWrapperState();
}

class _AddCourseScreenWrapperState extends State<AddCourseScreenWrapper> {
  CourseModel? course;
  bool skipSearch = false;

  @override
  void initState() {
    course = widget.course;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (course != null || skipSearch) {
      return AddCourseScreen(
        academicService: widget.academicService,
        course: course,
        courseId: widget.courseId,
      );
    }
    return SearchCourse(
      onItemClick: (_c) => setState(
        () {
          course = _c;
        },
      ),
      onSkip: () => setState(() {
        skipSearch = true;
      }),
    );
  }
}

class AddCourseScreen extends StatefulWidget {
  final AcademicService academicService;
  final CourseModel? course;
  final String? courseId;
  const AddCourseScreen(
      {Key? key, required this.academicService, this.course, this.courseId})
      : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  var _selectedSlots = <SlotModel>[];
  final _additionalSlotController = TextEditingController();
  final _notifyTime = TextEditingController(text: "10");
  List<SlotModel> _options = <SlotModel>[];
  bool notify = false;

  @override
  void initState() {
    if (widget.course != null) {
      var _c = widget.course!;
      _codeController.text = _c.courseCode;
      _nameController.text = _c.courseName;
      _options = _c.slots ?? [];
      _selectedSlots = _c.slots ?? [];
    }
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseId != null ? 'Edit Course' : 'Add Course',
          style: const TextStyle(
              letterSpacing: 1,
              color: Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 16.0),
              // if (_selectedSlots.isNotEmpty) const Text("Selected Slots"),
              // SlotsDisplay(
              //     slots: _selectedSlots,
              //     onDelete: (value) => setState(() {
              //           _selectedSlots = value;
              //         })),
              // CustomElevatedButton(
              //     padding: const [0, 3],
              //     onPressed: () {
              //       showModalBottomSheet(
              //         context: context,
              //         builder: (BuildContext context) => buildSheet(
              //             context,
              //             (controller) => SelectSlots(
              //                   selectedSlots: _selectedSlots,
              //                   controller: controller,
              //                   callback: (val) {
              //                     setState(() {
              //                       _selectedSlots = val;
              //                     });
              //                   },
              //                   slotConfig:
              //                       widget.academicService.getSlotOptions(),
              //                 )),
              //         isScrollControlled: true,
              //       );
              //     },
              //     text: 'Select Time Slots'),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _additionalSlotController,
                decoration: InputDecoration(
                    labelText: 'Slot Code (Click ✓ to add more slots)',
                    suffixIcon: IconButton(
                      onPressed: () {
                        final addOptions =
                            getSlotOptions(_additionalSlotController.text);
                        _options.addAll(addOptions);
                        // _selectedSlots.addAll(addOptions);
                        setState(() {
                          _options;
                          // _selectedSlots;
                        });
                        _additionalSlotController.clear();
                      },
                      icon: const Icon(Icons.check),
                    )),
              ),
              if (_options.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.builder(
                    itemCount: _options.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final slot = _options[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: _selectedSlots.contains(slot),
                            onChanged: (checked) {
                              setState(() {
                                if (checked!) {
                                  _selectedSlots.add(slot);
                                } else {
                                  _selectedSlots.remove(slot);
                                }
                              });
                            },
                          ),
                          Text(
                              '${slot.slotName.toUpperCase()} Slot - ${slot.day}: ${slot.fromTimeStr} - ${slot.toTimeStr}'),
                        ],
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Noitfy before the class?'),
                  Checkbox(
                    value: notify,
                    onChanged: (value) {
                      setState(() {
                        notify = value ?? !notify;
                      });
                    },
                  ),
                ],
              ),
              if (notify)
                TextFormField(
                  controller: _notifyTime,
                  decoration: const InputDecoration(
                      labelText: 'Notify before?', suffixIcon: Text('in mins')),
                  keyboardType: TextInputType.number,
                ),
              // ElevatedButton(
              //   child: const Text('Add Option'),
              //   onPressed: () async {
              //     final option = await showDialog<SlotModel>(
              //       context: context,
              //       builder: (context) => OptionDialog(),
              //     );
              //     if (option != null) {
              //       setState(() {
              //         _options.add(option);
              //       });
              //     }
              //   },
              // ),
              const SizedBox(height: 16.0),
              CustomElevatedButton(
                text: widget.courseId != null ? 'Edit Course' : 'Add Course',
                padding: const [25, 15],
                textSize: 18,
                color: ColorPalette.palette(context).primary,
                onPressed: () {
                  if (_selectedSlots.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Enter atleast one slot"),
                    ));
                    return;
                  }
                  if (_formKey.currentState!.validate() &&
                      _selectedSlots.isNotEmpty) {
                    final code = _codeController.text;
                    final name = _nameController.text;

                    try {
                      if (widget.courseId != null) {
                        widget.academicService.updateCourse(
                          widget.courseId!,
                          CourseModel(
                            courseCode: code,
                            courseName: name,
                            fromDate: widget.course?.fromDate ??
                                DateTime(2023, 1, 15),
                            toDate:
                                widget.course?.toDate ?? DateTime(2023, 5, 15),
                            slots: _selectedSlots,
                            reminder: notify ? int.parse(_notifyTime.text) : 0,
                          ),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Course Edited')),
                        );
                      } else {
                        widget.academicService.createCourse(
                          CourseModel(
                            courseCode: code,
                            courseName: name,
                            fromDate: widget.course?.fromDate ??
                                DateTime(2023, 1, 15),
                            toDate:
                                widget.course?.toDate ?? DateTime(2023, 5, 15),
                            slots: _selectedSlots,
                            reminder: int.parse(_notifyTime.text),
                          ),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Course Created')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Some Error Occured. Retry!')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlotsDisplay extends StatelessWidget {
  final List<SlotModel> slots;
  final Function onDelete;

  const SlotsDisplay({
    Key? key,
    required this.slots,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: List.generate(slots.length, (index) {
          final slot = slots[index];
          return Chip(
            label: Text(
                '${slot.slotName.toUpperCase()} Slot - ${slot.day}: ${slot.fromTimeStr} - ${slot.toTimeStr}'),
            padding: const EdgeInsets.all(4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: const Icon(Icons.close, size: 20),
            onDeleted: () {
              slots.remove(slot);
              onDelete(slots);
            },
          );
        }),
      ),
    );
  }
}

class SelectSlots extends StatefulWidget {
  final List<SlotModel> selectedSlots;
  final ScrollController controller;
  final Function? callback;
  final List<Map<String, dynamic>> slotConfig;

  // final CategoryModel? additionalCategory;
  const SelectSlots(
      {Key? key,
      required this.selectedSlots,
      required this.controller,
      required this.slotConfig,
      this.callback})
      : super(key: key);

  @override
  State<SelectSlots> createState() => _SelectSlotsState();
}

class _SelectSlotsState extends State<SelectSlots> {
  late List<SlotModel> selectedSlots;
  List<String> minimizedCategorys = [];

  @override
  void initState() {
    selectedSlots = widget.selectedSlots;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
                controller: widget.controller,
                itemCount: widget.slotConfig.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final category = widget.slotConfig[index];
                  final isMinimized =
                      minimizedCategorys.contains(category["slotName"]);
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () => isMinimized
                                ? setState(() {
                                    minimizedCategorys
                                        .remove(category["slotName"]);
                                  })
                                : setState(() {
                                    minimizedCategorys
                                        .add(category["slotName"]);
                                  }),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    category["slotName"],
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                isMinimized
                                    ? const Icon(Icons.arrow_drop_down)
                                    : const Icon(Icons.arrow_drop_up)
                              ],
                            ),
                          ),
                        ),
                        if (!isMinimized)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: List.generate(
                                    category["slots"].length, (index1) {
                                  var isSelected = false;
                                  var _slot =
                                      category["slots"][index1] as SlotModel;
                                  for (var i = 0;
                                      i < selectedSlots.length;
                                      i++) {
                                    var e = selectedSlots[i];
                                    if (e.day == _slot.day &&
                                        e.fromTime == _slot.fromTime &&
                                        e.toTime == _slot.toTime &&
                                        e.slotName == _slot.slotName) {
                                      isSelected = true;
                                    }
                                  }
                                  return InkWell(
                                    onTap: () {
                                      isSelected
                                          ? selectedSlots.remove(
                                              category["slots"][index1]
                                                  as SlotModel)
                                          : selectedSlots.add(category["slots"]
                                              [index1] as SlotModel);
                                      setState(() {
                                        selectedSlots;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFE1E0EC)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: const Color(0xFFE1E0EC)),
                                          borderRadius:
                                              BorderRadius.circular(17)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 11),
                                      child: Text(
                                          category["slots"][index1].day +
                                              ": " +
                                              category["slots"][index1]
                                                  .fromTimeStr +
                                              " - " +
                                              category["slots"][index1]
                                                  .toTimeStr,
                                          style: const TextStyle(
                                              color: Color(0xFF3C3C3C))),
                                    ),
                                  );
                                })),
                          ),
                      ]);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.callback!(selectedSlots);
                },
                padding: const [27, 16],
                text: "Apply"),
          )
        ],
      ),
    );
  }
}
