import 'package:flutter/material.dart';


///Loading screens
class NewCardSkeleton extends StatelessWidget {
  const NewCardSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25,25,0,25),
      child: Column(
        children: [
          Row(
            children: [
              Skeleton(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.65,
              ),
              const SizedBox(
                width: 10,
              ),
              Skeleton(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.09,
              ),
              const SizedBox(
                width: 10,
              ),
              Skeleton(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.09,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Skeleton(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.875,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
