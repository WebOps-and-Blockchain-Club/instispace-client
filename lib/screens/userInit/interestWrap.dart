import 'package:client/models/tag.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:flutter/material.dart';

class interestWrap extends StatefulWidget {
  Map<String, List<Tag>> interest;
  Map<String, List<Tag>>? selectedInterest;
  interestWrap({required this.interest, required this.selectedInterest});

  @override
  _interestWrapState createState() => _interestWrapState();
}

class _interestWrapState extends State<interestWrap> {
  @override
  Widget build(BuildContext context) {
    print("Widget built again");
    print("condition:${widget.selectedInterest!.isNotEmpty}");
    print("selected Interests: ${widget.selectedInterest}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        if(widget.selectedInterest!.isNotEmpty)
        FormText("Selected Interests"),
        Wrap(
          children: widget.selectedInterest!.keys.map((String key) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Wrap(
                    children: widget.selectedInterest![key]!
                        .map(
                          (s) => ElevatedButton(
                            onPressed: () => {
                              setState(() {
                                widget.interest.putIfAbsent(key, () => []);
                                widget.interest[key]!.add(s);
                                widget.selectedInterest![key]!.remove(s);
                                if(widget.selectedInterest![key]!.toList().isEmpty){
                                  widget.selectedInterest!.remove(key);
                                  print("selected interest keys:${widget.selectedInterest!.keys.toList()}");
                                }
                              })
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8,2,8,2),
                              child: Text(
                                s.Tag_name,
                                style: const TextStyle(
                                  color: Color(0xFF2B2E35),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0x2B2E35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                // side: BorderSide(color: Color(0xFF2B2E35)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6),
                                minimumSize: const Size(35, 30)
                            ),
                          )
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        SizedBox(height: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.interest.keys.map((String key) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormText(key),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Wrap(
                    children: widget.interest[key]!
                        .map(
                          (s) =>ElevatedButton(
                            onPressed: () => {
                              setState(() {
                                widget.selectedInterest!
                                    .putIfAbsent(key, () => []);
                                widget.selectedInterest![key]!.add(s);
                                widget.interest[key]!.remove(s);
                                if (widget.interest[key]!.isEmpty) {
                                  widget.interest.remove(key);
                                }
                              })
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8,2,8,2),
                              child: Text(
                                s.Tag_name,
                                style: const TextStyle(
                                  color: Color(0xFF2B2E35),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFDFDFDF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                // side: BorderSide(color: Color(0xFF2B2E35)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6),
                                minimumSize: const Size(35, 30)
                            ),
                          )
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
