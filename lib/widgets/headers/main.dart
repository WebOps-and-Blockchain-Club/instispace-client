import 'dart:async';
import 'package:flutter/material.dart';

import '../../themes.dart';
import '../marquee.dart';

class Header extends StatelessWidget {
  final String title;
  final String? subTitle;
  const Header({Key? key, required this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarqueeWidget(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorPalette.palette(context).secondary,
                fontWeight: FontWeight.w500),
          )
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? action;
  const CustomAppBar({Key? key, required this.title, this.leading, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: SizedBox(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading != null ? leading! : const SizedBox(width: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: MarqueeWidget(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            action != null ? action! : const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  final String? error;
  final void Function()? onFilterClick;
  final EdgeInsetsGeometry? padding;
  final List<ChipModel>? chips;
  final List<String>? selectedChips;
  final Function? onChipFilter;
  final int? time;
  const SearchBar(
      {Key? key,
      required this.onSubmitted,
      this.error,
      this.onFilterClick,
      this.padding,
      this.chips,
      this.selectedChips,
      this.onChipFilter,
      this.time})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  int? time;
  Debouncer _debouncer = Debouncer();
  final search = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        time = widget.time;
        _debouncer = Debouncer(milliseconds: time);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: Expanded(
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
                    contentPadding: EdgeInsets.all(5),
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
                onSubmitted: widget.onSubmitted,
                onChanged: (value) {
                  _debouncer.run(() {
                    widget.onSubmitted(value);
                  });
                },
              ),
            )),
            /*if (widget.onFilterClick != null)
                  Card(
                    margin: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: widget.onFilterClick,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.filter_alt_outlined),
                      ),
                    ),
                  )*/
          ),
          if (widget.error != null && widget.error != "")
            SizedBox(
              height: 18,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.error!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: ColorPalette.palette(context).error),
                ),
              ),
            ),
          if (widget.chips != null &&
              widget.chips!.isNotEmpty &&
              widget.selectedChips != null)
            SizedBox(
              height: 22,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: List.generate(widget.chips!.length, (index) {
                    return InkWell(
                      onTap: () {
                        widget.selectedChips!.contains(widget.chips![index].id)
                            ? widget.selectedChips!
                                .remove(widget.chips![index].id)
                            : widget.selectedChips!
                                .add(widget.chips![index].id);
                        if (widget.onChipFilter != null) {
                          widget.onChipFilter!(widget.selectedChips);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.selectedChips!
                                    .contains(widget.chips![index].id)
                                ? Colors.purple[100]
                                : Colors.transparent,
                            border: Border.all(
                                color: ColorPalette.palette(context).secondary),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Text(widget.chips![index].name),
                      ),
                    );
                  }),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ChipModel {
  final String id;
  final String name;

  ChipModel({required this.id, required this.name});
}

class Debouncer {
  int? seconds;
  VoidCallback? action;
  Timer? timer;
  int? milliseconds;
  Debouncer({
    this.seconds,
    this.milliseconds,
  });

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      //Duration(seconds: seconds ?? 2),
      Duration(milliseconds: milliseconds ?? 2000),
      action,
    );
  }
}
