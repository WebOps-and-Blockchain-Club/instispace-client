import 'package:flutter/material.dart';

void navigate(BuildContext context, Widget to) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => to));
}
