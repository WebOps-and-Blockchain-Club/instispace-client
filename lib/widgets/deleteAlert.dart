import 'package:flutter/material.dart';

class DeleteAlert extends StatefulWidget {

  final BuildContext context;
  final Widget deleteButton;

  DeleteAlert({required this.deleteButton, required this.context});

  @override
  _DeleteAlertState createState() => _DeleteAlertState();
}

class _DeleteAlertState extends State<DeleteAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Delete Post",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      content: const Text("Are you sure you want to delete this post"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(widget.context);
          },
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF2B2E35),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            minimumSize: const Size(80, 35),
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(15,5,15,5),
            child: Text('Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        widget.deleteButton,
      ],
    );
  }
}
