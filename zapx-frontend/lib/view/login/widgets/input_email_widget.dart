import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/login/login_view_model.dart';
import 'package:zapxx/view_model/user_view_model.dart';

import '../../../configs/utils.dart';

class InputEmailWidget extends StatelessWidget {
  final FocusNode focusNode, passwordFocusNode;
  const InputEmailWidget(
      {super.key, required this.focusNode, required this.passwordFocusNode});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: focusNode,
        decoration: const InputDecoration(
            hintText: 'Email',
            labelText: 'Email',
            prefixIcon: Icon(Icons.alternate_email)),
        onFieldSubmitted: (value) {
          Utils.fieldFocusChange(context, focusNode, passwordFocusNode);
        },
        onChanged: (value) {
          provider.setEmail(value);
        },
      );
    });
  }
}
