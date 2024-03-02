import 'package:flutter/material.dart';

class PrimaryFilter<T> extends StatefulWidget {
  final List<T> options;
  final String Function(T) optionTextBuilder;
  final IconData? Function(T)? optionIconBuilder;
  final void Function(List<T>) onSelect;

  const PrimaryFilter(
      {Key? key,
      required this.options,
      required this.optionTextBuilder,
      this.optionIconBuilder,
      required this.onSelect})
      : super(key: key);

  @override
  State<PrimaryFilter<T>> createState() => _PrimaryFilterState<T>();
}

class _PrimaryFilterState<T> extends State<PrimaryFilter<T>> {
  late List<T> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    final List<T> options = widget.options;
    return SizedBox(
      height: 30,
      child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedOptions.contains(options[index])) {
                        selectedOptions.remove(options[index]);
                      } else {
                        selectedOptions.add(options[index]);
                      }
                    });
                    widget.onSelect(selectedOptions);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: selectedOptions.contains(options[index])
                            ? Theme.of (context).brightness == Brightness.dark  ? Colors.white : Colors.black
                            : Theme.of (context).brightness == Brightness.dark ? const Color.fromARGB(255, 52, 52, 52) :const Color(0xFFEEEEEE),
                        borderRadius: BorderRadiusDirectional.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                           horizontal: 13),
                      child: Row(
                        children: [
                          if (widget.optionIconBuilder != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                widget.optionIconBuilder!(options[index]),
                                size: 15,
                                color: selectedOptions.contains(options[index])
                                    ? Theme.of (context).brightness == Brightness.dark  ? Colors.black :  Colors.white
                                    : Theme.of (context).brightness == Brightness.dark  ? Colors.white : const Color(0xFF505050),
                              ),
                            ),
                          Text(
                            widget.optionTextBuilder(options[index]),
                            style: TextStyle(
                                fontSize: 15,
                                color: selectedOptions.contains(options[index])
                                    ? Theme.of (context).brightness == Brightness.dark  ? Colors.black :  Colors.white
                                    : Theme.of (context).brightness == Brightness.dark  ? Colors.white : const Color(0xFF505050)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
