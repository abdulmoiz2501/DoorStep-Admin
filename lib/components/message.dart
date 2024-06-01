import 'package:flutter/material.dart';
import 'package:project_admin/constants.dart';

void error(BuildContext? context, {required String message}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  ));
}

void success(BuildContext? context, {required String message}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: kAccentColor,
  ));
}
