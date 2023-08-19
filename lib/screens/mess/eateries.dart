import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../utils/eateries.dart';
import '../../widgets/form/dropdown_button.dart';
import 'dayMenu.dart';
import 'menuCard.dart';

// const eateriesMap = {"tea": {"supplier": "Zaitoon", "price": "10", "isVeg": false}, "Black Tea": {"supplier": "Usha", "price": "12", "isVeg": true},"yellow tea": {"supplier": "Zaitoon", "price": "10", "isVeg": true},"green tea": {"supplier": "Zaitoon", "price": "10", "isVeg": true},"blue tea": {"supplier": "Usha", "price": "10", "isVeg": true},"white tea": {"supplier": "Usha", "price": "10", "isVeg": true}};
class EateriesMenuScreen extends StatefulWidget {
  const EateriesMenuScreen({super.key});

  @override
  State<EateriesMenuScreen> createState() => _EateriesMenuScreenState();
}

class _EateriesMenuScreenState extends State<EateriesMenuScreen> {
  bool isVegetarian = true;
  bool isNonVegetarian = true;

  void toggleVeg(bool value) {
    setState(() {
      isVegetarian = value;
    });
  }
  void toggleNonVeg(bool value) {
    setState(() {
      isNonVegetarian = value;
    });
  }

  late String eatery = 'Zaitoon';
  @override
  Widget build(BuildContext context) {
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
                  'Chaat Corner',
                  'Deli pizzeria',
                  'Hotel Ananda',
                  'Vineyard',
                  'Chai Waale',
                  'Waah Hyderabadi',
                  'Coolbiz(HFC)',
                  'CCD'
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
            // MapCardWidget(heading:"TIMINGS", dataMap: eateriesMap, eatery: eatery,),
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
                    "Timings",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.food_bank,
                    color: Colors.black,
                  ),
                ],
              )),
          Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.eco,
        ),
        Switch(
          value: isVegetarian,
          onChanged: toggleVeg,
        ),
        Icon(
          Icons.egg,
        ),
        Switch(
          value: isNonVegetarian,
          onChanged: toggleNonVeg,
        ),
      ],
    ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    eateriesMap.keys.where((key) => eateriesMap[key]?['supplier']==eatery && eateriesMap[key]?['isVeg']== isVegetarian).length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 225,
                                child: Expanded(
                                  child: Text(
                                    eateriesMap.keys.where((key) => (eateriesMap[key]?['supplier']==eatery && eateriesMap[key]?['isVeg']== isVegetarian ) ).elementAt(index) ,
                                    style: const TextStyle(fontSize: 14),
                                    // overflow: TextOverflow.ellipsis,
                                    // softWrap: true,
                                    // maxLines: 3
                                  ),
                                ),
                              ),
                              Text("${eateriesMap.values.where((value) => value['supplier']== eatery && value['isVeg']== isVegetarian).elementAt(index)["price"]}"
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



// class MapCardWidget extends StatelessWidget {
//   final String heading;
//   final Map<String, dynamic> dataMap;
//   final String eatery;

//   MapCardWidget({required this.heading, required this.dataMap,required this.eatery});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 4,
//       margin: EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               heading,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Column(
//           children: eateriesMap.keys
//               .where((key) => eateriesMap[key]?['supplier'] == eatery)
//               .map((key) => Card(
//                     child: ListTile(
//                       title: Text(key),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Price: ${eateriesMap[key]?['price']}'),
//                           Text('Is Veg: ${eateriesMap[key]?['isVeg']}'),
//                         ],
//                       ),
//                     ),
//                   ))
//               .toList(),
//         ),
//       ]
//       ),
//         ));
//   }
// }