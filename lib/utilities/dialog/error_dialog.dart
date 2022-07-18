import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context,String text)
{
  return showGenericDialog<void>(context: context, title: 'An error accoured', content: text, optionBuilder: () =>{'OK':null},);
}