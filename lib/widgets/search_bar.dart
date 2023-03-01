import 'dart:async';
import 'package:flutter/material.dart';

import '../themes.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  final EdgeInsetsGeometry? padding;
  const SearchBar({Key? key, required this.onSubmitted, this.padding})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  int? time;
  Debouncer _debouncer = Debouncer();
  final search = TextEditingController();
  late String error = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _debouncer = Debouncer(seconds: 2);
      });
    });
  }

  void onSubmit(String value) {
    if (value.isEmpty || value.length >= 4) {
      widget.onSubmitted(value);
      setState(() {
        error = "";
      });
    } else {
      setState(() {
        error = "Enter at least 4 characters";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
            child: Theme(
              data: ThemeData(
                primarySwatch: ColorPalette.palette(context).primary,
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                maxLength: 50,
                controller: search,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE1E0EC),
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(35)),
                    //hintText: 'What are you looking for?',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 25,
                      color: Color(0xFFB5B4CA),
                    ),
                    suffixIcon: search.text == ""
                        ? null
                        : IconButton(
                            onPressed: () {
                              search.clear();
                              widget.onSubmitted("");
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 25,
                            )),
                    counterText: ""),
                onSubmitted: onSubmit,
                onChanged: (value) {
                  _debouncer.run(() {
                    onSubmit(value);
                  });
                },
              ),
            ),
          ),
          if (error != "")
            SizedBox(
              height: 18,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  error,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: ColorPalette.palette(context).error),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Debouncer {
  int? seconds;
  VoidCallback? action;
  Timer? timer;

  Debouncer({this.seconds});

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(seconds: seconds ?? 2),
      action,
    );
  }
}
