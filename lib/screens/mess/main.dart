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
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

Map<String, MealModel> mealMap = {
  "Breakfast": MealModel(
    icon: Icons.breakfast_dining_outlined,
    color: const Color(0xFF342F81),
  ),
  "Lunch": MealModel(
      icon: Icons.lunch_dining_outlined, color: const Color(0xFF03A2DC)),
  "Dinner": MealModel(
      icon: Icons.dinner_dining_outlined, color: const Color(0xFFB31F81))
};

List<String> weekDays = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday'
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

  void setMess(mess) async {
    await localStorage.setData("mess", {"menu": mess});
  }

  getData() async {
    return await localStorage.getData("mess");
  }

  @override
  void initState() {
    getData().then((data) => {
          if (data != null)
            {
              setState(() {
                mess = data['menu'];
              })
            }
          else
            {
              setState(() {
                mess = 'Vindhya-South';
              })
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              children: [
                CustomAppBar(
                    title: "MESS MENU",
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                CustomDropdownButton(
                  value: mess,
                  items: const [
                    'Vindhya-South',
                    'Vindhya-North',
                    'North',
                    'South'
                  ],
                  onChanged: (p0) {
                    if (p0 != null) {
                      setState(() {
                        mess = p0;
                      });
                      setMess(p0);
                    }
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 20),
                      child: CustomElevatedButton(
                          elevation: 2,
                          textSize: 14,
                          onPressed: () {},
                          color: (index + 1 == day)
                              ? ColorPalette.palette(context).secondary
                              : Colors.white,
                          textColor:
                              (index + 1 == day) ? Colors.white : Colors.black,
                          text: weekdayName[index + 1]!
                              .substring(0, 3)
                              .toUpperCase()),
                    );
                  })),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return DayMenu(
                          date: DateTime.now().add(Duration(days: index)),
                        );
                      })),
                ),
              ],
            )));
  }
}
