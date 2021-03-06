import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';

class UIHelper {
  static InputDecoration roundedInputDecoration({String hintText}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: purple),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  static Widget successfulSnackBar({String message}) {
    return SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget unsuccessfulSnackBar({String message}) {
    return SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
