import 'package:accounts/utility/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "AN error occurred",
    content: text,
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
