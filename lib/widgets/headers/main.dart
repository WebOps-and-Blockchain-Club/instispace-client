import 'package:flutter/material.dart';

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
        Text(
          title,
          style: const TextStyle(
              color: Color(0xFF2f247b),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: const TextStyle(
                color: Colors.purple,
                fontSize: 16,
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
            leading != null ? leading! : const SizedBox(width: 40),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF2f247b),
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            action != null ? action! : const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final void Function(String) onSubmitted;
  final void Function()? onFilterClick;
  final EdgeInsetsGeometry? padding;
  const SearchBar(
      {Key? key, required this.onSubmitted, this.onFilterClick, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
      padding: padding,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What are you looking for?',
                        prefixIcon: Icon(Icons.search)),
                    onSubmitted: onSubmitted,
                  ))),
          if (onFilterClick != null)
            Card(
              margin: const EdgeInsets.only(left: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: InkWell(
                onTap: onFilterClick,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child:
                      Icon(Icons.filter_alt_outlined, color: Color(0xFF2f247b)),
                ),
              ),
            )
        ],
      ),
    );
  }
}
