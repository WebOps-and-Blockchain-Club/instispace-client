import 'package:client/models/tag.dart';
import 'package:flutter/material.dart';
class interestWrap extends StatefulWidget {
  Map<String,List<Tag>> interest;
  Map<String,List<Tag>>? selectedInterest;
  interestWrap({required this.interest,required this.selectedInterest});

  @override
  _interestWrapState createState() => _interestWrapState();
}

class _interestWrapState extends State<interestWrap> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*1,
          height: 100.0,
          child: Wrap(
                  children: widget.selectedInterest!.keys.map((String key) {
                    return Column(
                      children: [
                        new Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Wrap(
                            children: widget.selectedInterest![key]!.map((s)=>
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: MaterialButton(//shape,color etc...
                                    onPressed: () {
                                      setState(() {
                                        widget.interest.putIfAbsent(key,()=>[]);
                                        widget.interest[key]!.add(s);
                                        widget.selectedInterest![key]!.remove(s);
                                      });
                                    },
                                    child: Text(s.Tag_name),
                                    color: Colors.green,
                                  ),
                                ),
                            ).toList(),
                          ),
                        ),
                      ],
                    );
                  }
                  ).toList(),
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          width: MediaQuery.of(context).size.width*1,
          height: 500.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.interest.keys.map((String key) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(key),
                  new Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Wrap(
                      children: widget.interest[key]!.map((s)=>
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: MaterialButton(//shape,color etc...
                              onPressed: () {
                                setState(() {
                                  widget.selectedInterest!.putIfAbsent(key,()=>[]);
                                  widget.selectedInterest![key]!.add(s);
                                  widget.interest[key]!.remove(s);
                                  if(widget.interest[key]!.isEmpty){
                                    widget.interest.remove(key);
                                  }
                                });
                              },
                              child: Text(s.Tag_name),
                              color: Colors.green,
                            ),
                          ),
                      ).toList(),
                    ),
                  ),
                ],
              );
            }
            ).toList(),
          ),
        ),
      ],
    );
  }
}
