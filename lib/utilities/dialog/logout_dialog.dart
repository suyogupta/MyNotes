import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context)
{
  return showGenericDialog<bool>(context: context, title: 'Logout', content: 'Are you sure you want to log out?', optionBuilder: () =>{'Cancel':false,'Log out':true},).then((value) => value ?? false);
}