import 'package:client/models/mess.dart';
import 'package:client/screens/mess/dayMenu.dart';
import 'package:client/screens/mess/menuCard.dart';
import 'package:client/services/local_storage.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/form/dropdown_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Map<String, MealModel> mealMap = {
  "Breakfast": MealModel(
      icon: Icons.breakfast_dining_outlined, color: const Color(0xFFB31F81)),
  "Lunch": MealModel(
    icon: Icons.lunch_dining_outlined,
    color: const Color(0xFF342F81),
  ),
  "Dinner": MealModel(
      icon: Icons.dinner_dining_outlined, color: const Color(0xFF03A2DC))
};

List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class MessMenuScreen extends StatefulWidget {
  const MessMenuScreen({Key? key}) : super(key: key);

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {
  final localStorage = LocalStorageService();
  late String mess = 'Vindhya-South';
  int day = DateTime.now().weekday;
  late String week = 'odd';
  late Map<int, int> indexMap = {};

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final scrollController = ScrollController();

  void setData(mess, week) async {
    await localStorage.setData("mess", {"menu": mess, "week": week});
  }

  getData() async {
    return await localStorage.getData("mess");
  }

  void setIndexMap() {
    final list = [
      ...weekDays.sublist(day - 1),
      ...weekDays.sublist(0, day - 1)
    ];
    for (int i = 0; i < weekDays.length; i++) {
      final index = list.indexOf(weekDays[i]);
      setState(() {
        indexMap[i] = index;
      });
    }
  }

  @override
  void initState() {
    setIndexMap();

    if (day > 4) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              ));
    }

    getData().then((data) => {
          if (data != null)
            {
              setState(() {
                if (data['menu'] != null) mess = data['menu'];
                if (data['week'] != null) week = data['week'];
              })
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: CustomAppBar(
              title: "MESS MENU",
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).pop(),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    week = 'odd';
                  });
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  backgroundColor: week == 'odd'
                      ? const Color(0xFFD4D2ED)
                      : const Color(0xFFE6E6E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "ODD WEEK",
                  style: TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                )),
            const SizedBox(width: 10),
            TextButton(
                onPressed: () {
                  setState(() {
                    week = 'even';
                  });
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  backgroundColor: week == 'even'
                      ? const Color(0xFFD4D2ED)
                      : const Color(0xFFE6E6E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "EVEN WEEK",
                  style: TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomDropdownButton(
            padding: const EdgeInsets.all(0),
            value: mess,
            items: const ['Vindhya-South', 'Vindhya-North', 'North', 'South'],
            onChanged: (p0) {
              if (p0 != null) {
                setState(() {
                  mess = p0;
                });
              }
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(7, (index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
                child: CustomElevatedButton(
                    elevation: 2,
                    textSize: 14,
                    onPressed: () {
                      itemScrollController.scrollTo(
                          index: indexMap[index]!,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeInOutCubic);
                      setState(() {
                        day = index + 1;
                      });
                    },
                    color: (index + 1 == day)
                        ? ColorPalette.palette(context).secondary
                        : Colors.white,
                    textColor: (index + 1 == day) ? Colors.white : Colors.black,
                    text: weekDays[index].substring(0, 3).toUpperCase()),
              );
            })),
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 7,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemBuilder: ((context, index) {
                return DayMenu(
                  mess: mess,
                  week: week,
                  date: DateTime.now().add(Duration(days: index)),
                );
              })),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    setData(mess, week);
    super.dispose();
  }
}
