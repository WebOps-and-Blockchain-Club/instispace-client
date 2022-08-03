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
                    style: Theme.of(context).textTheme.headlineSmall,
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

class SearchBar extends StatelessWidget {
  final void Function(String) onSubmitted;
  final String? error;
  final void Function()? onFilterClick;
  final EdgeInsetsGeometry? padding;
  final List<ChipModel>? chips;
  final List<String>? selectedChips;
  final Function? onChipFilter;
  const SearchBar(
      {Key? key,
      required this.onSubmitted,
      this.error,
      this.onFilterClick,
      this.padding,
      this.chips,
      this.selectedChips,
      this.onChipFilter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.palette(context).secondary[50],
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Card(
                        margin: const EdgeInsets.all(0),
                        child: Theme(
                          data: ThemeData(
                            primarySwatch:
                                ColorPalette.palette(context).primary,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'What are you looking for?',
                                prefixIcon: Icon(Icons.search, size: 25)),
                            onSubmitted: onSubmitted,
                          ),
                        ))),
                if (onFilterClick != null)
                  Card(
                    margin: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: onFilterClick,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.filter_alt_outlined),
                      ),
                    ),
                  )
              ],
            ),
          ),
          if (error != null && error != "")
            SizedBox(
              height: 18,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  error!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: ColorPalette.palette(context).error),
                ),
              ),
            ),
          if (chips != null && chips!.isNotEmpty && selectedChips != null)
            SizedBox(
              height: 22,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: List.generate(chips!.length, (index) {
                    return InkWell(
                      onTap: () {
                        selectedChips!.contains(chips![index].id)
                            ? selectedChips!.remove(chips![index].id)
                            : selectedChips!.add(chips![index].id);
                        if (onChipFilter != null) onChipFilter!(selectedChips);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: selectedChips!.contains(chips![index].id)
                                ? Colors.purple[100]
                                : Colors.transparent,
                            border: Border.all(
                                color: ColorPalette.palette(context).secondary),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Text(chips![index].name),
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
