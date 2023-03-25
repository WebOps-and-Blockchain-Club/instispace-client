import 'package:flutter/material.dart';
import 'dart:io' as io;

class ImageView extends StatefulWidget {
  final List<io.File>? images;

  final Function onDelete;
  const ImageView({Key? key, required this.images, required this.onDelete})
      : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    dynamic imgs = widget.images;
    return SizedBox(
      height: 310,
      child: PageView.builder(
          itemCount: imgs.length,
          itemBuilder: ((context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 280,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  image: DecorationImage(
                    image: FileImage(imgs[index]),
                    fit: BoxFit.cover,
                  )),
              child: IconButton(
                style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.4)),
                icon: const Icon(Icons.clear,
                    color: Colors.white,
                    size: 40,
                    shadows: <Shadow>[
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 20,
                          spreadRadius: 20,
                          offset: Offset(2, 2))
                    ]),
                onPressed: () => widget.onDelete(imgs[index]),
              ),
            );
          })),
    );
  }
}
