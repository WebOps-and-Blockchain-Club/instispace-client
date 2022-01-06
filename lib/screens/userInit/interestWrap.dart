import 'package:flutter/material.dart';
class interestWrap extends StatefulWidget {
  List<String> interest;
  List<String> selectedInterest;
  interestWrap({required this.interest,required this.selectedInterest});

  @override
  _interestWrapState createState() => _interestWrapState();
}

class _interestWrapState extends State<interestWrap> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
            children: widget.selectedInterest.map((s) =>
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(//shape,color etc...
                    onPressed: () {
                      setState(() {
                        widget.interest.add(s);
                        widget.selectedInterest.remove(s);
                      });
                    },
                    child: Text(s),
                    color: Colors.green,
                  ),
                )).toList()),
        SizedBox(height: 10.0),
        Wrap(
        children: widget.interest.map((s) =>
        Padding(
        padding: const EdgeInsets.all(4.0),
        child: MaterialButton(
        //shape,color etc...
        onPressed: () {
        setState(() {widget.selectedInterest.add(s);
        widget.interest.remove(s);
        });
        },
        child: Text(s),
        color: Colors.grey,
        ),
        )).toList()),
      ],
    );
  }
}
