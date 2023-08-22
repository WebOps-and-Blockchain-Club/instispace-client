import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../utils/eateries.dart';
import '../../widgets/form/dropdown_button.dart';

class EateriesMenuScreen extends StatefulWidget {
  const EateriesMenuScreen({super.key});

  @override
  State<EateriesMenuScreen> createState() => _EateriesMenuScreenState();
}

class _EateriesMenuScreenState extends State<EateriesMenuScreen> {
  bool isVegetarian = true;
  bool isNonVegetarian = true;
  late String eatery = 'Zaitoon';
  Map filteredEateriesMap = {};
  Map timings = {'Usha':'8:30 am - 2:00 am','Zaitoon':'8:30 am - 1:00 am','Coolbiz usha':'9:00 am - 1:00 am','CCD':'24/7','Hotel Ananda':'6:00 am - 11:00 pm','Deli Pizzeria':'11:00 am - 11:30 pm','Vineyard':'10:00 am - 2:00 am','Waah Hyderabadi':'12:00 pm - 12:00 am','Chaat Corner':'11:00 am - 9:30 pm','Chai waale':'8:00 am - 2:00 am','Cool Biz':'9:30 am - 1:00 am'};

  void updateFilteredEateries() {
    filteredEateriesMap.clear();
    eateriesMap.forEach((key, value) {
      if (((isVegetarian && value["isVeg"]) ||
          (isNonVegetarian && !value["isVeg"])) &&
          value["supplier"] == eatery) {
        filteredEateriesMap[key] = value;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    updateFilteredEateries();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Eateries Menu",
          style: TextStyle(letterSpacing: 1,
                color: Color(0xFF3C3C3C),
                fontSize: 20,
                fontWeight: FontWeight.w700)
                ),

      ),
      body: Column(children: [
        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDropdownButton(
                padding: const EdgeInsets.all(0),
                value: eatery,
                items: const [
                  'Zaitoon',
                  'Usha',
                  'Coolbiz usha',
                  'CCD',
                  'Deli Pizzeria',
                  'Hotel Ananda',
                  'Waah Hyderabadi',
                  'Chaat Corner',
                  'Vineyard',
                  'Cool Biz',
                  'Chai Waale'
                ],
                onChanged: (p0) {
                  if (p0 != null) {
                    setState(() {
                      eatery = p0;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: ((context, index) {
                    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(2, 2),
                blurRadius: 16)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)),
              ),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Text(
                    "Timings: ${timings[eatery]}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(
                    Icons.food_bank,
                    color: Colors.black,
                  ),
                ],
              )),
          ToggleSwitch(
            initialLabelIndex: isVegetarian
                ? (isNonVegetarian ? 2 : 0)
                : (isNonVegetarian ? 1 : 2),
            totalSwitches: 3,
            customWidths: [50.0, 75.0, 50.0],
            labels: const ['Veg', 'Non Veg', 'All'],
            activeBgColors: const [ [Colors.green] ,[Colors.red],[Colors.blue]],
            onToggle: (index) {
                  setState(() {
                    if (index == 0) {
                      isVegetarian = true;
                      isNonVegetarian = false;
                    } else if (index == 1) {
                      isVegetarian = false;
                      isNonVegetarian = true;
                    } else if (index == 2) {
                      isVegetarian = true;
                      isNonVegetarian = true;
                    }
                    updateFilteredEateries();
                  });
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    (filteredEateriesMap.keys).length,
                    // eateriesMap.keys.where((key) => eateriesMap[key]?['supplier']==eatery && eateriesMap[key]?['isVeg']== isVegetarian).length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 225,
                                child: Text(
                                  filteredEateriesMap.keys.elementAt(index),
                                  // eateriesMap.keys.where((key) => (eateriesMap[key]?['supplier']==eatery && eateriesMap[key]?['isVeg']== isVegetarian ) ).elementAt(index) ,
                                  style: const TextStyle(fontSize: 14),
                                  // softWrap: true,
                                  // maxLines: 3
                                ),
                              ),
                              Text(
                                filteredEateriesMap.values.elementAt(index)['price']
                                // "${eateriesMap.values.where((value) => value['supplier']== eatery && value['isVeg']== isVegetarian).elementAt(index)["price"]}"
                              )
                            ],
                          ),
                        ))),
          ),
        
        ],
      ),
    ) ;
                  })),
            ),
            
      ],)
    );
  }
}