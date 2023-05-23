import 'package:flutter/material.dart';

showAlertDialog(
  BuildContext context,
  String title,
  String desc,
  VoidCallback handleYes,
) {
  Future handleOk() async {
    handleYes();
    Navigator.of(context).pop();
  }

  // set up the button
  Widget yesButton = ElevatedButton(
    child: const Text("Yes"),
    onPressed: handleOk,
  );

  // set up the button
  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed: () {
      // Do something when the user selects "No"
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(desc),
    actions: [
      noButton,
      yesButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
