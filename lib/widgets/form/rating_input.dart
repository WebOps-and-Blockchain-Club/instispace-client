import 'package:client/themes.dart';
import 'package:flutter/material.dart';

class RatingInput extends StatelessWidget {
  final int value;
  final Function? onChange;
  const RatingInput({Key? key, required this.value, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, int index) {
          return Container(
            margin: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: (index < value)
                  ? ratingColors[value - 1]
                  : ColorPalette.palette(context).secondary[50],
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    ratingIcons[index],
                    color: (index < value)
                        ? ColorPalette.palette(context).primary
                        : ratingColors[index],
                    size: 30,
                  ),
                  onPressed: () {
                    onChange!(index);
                  }),
            ),
          );
        },
      ),
    );
  }
}

List<dynamic> ratingColors = [
  Colors.red,
  Colors.redAccent,
  Colors.amber,
  Colors.lightGreen,
  Colors.green
];
List<dynamic> ratingIcons = [
  Icons.sentiment_very_dissatisfied,
  Icons.sentiment_dissatisfied,
  Icons.sentiment_neutral,
  Icons.sentiment_satisfied,
  Icons.sentiment_very_satisfied
];
