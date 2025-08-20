import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/login/login_view_model.dart';
import 'package:zapxx/view_model/user_view_model.dart';

class InputPasswordWidget extends StatelessWidget {
  InputPasswordWidget({super.key, required this.focusNode});

  final FocusNode focusNode;
  final ValueNotifier<bool> _obSecurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return ValueListenableBuilder(
          valueListenable: _obSecurePassword,
          builder: (context, value, child) {
            return TextFormField(
              obscureText: _obSecurePassword.value,
              focusNode: focusNode,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_open_rounded),
                suffixIcon: InkWell(
                    onTap: () {
                      _obSecurePassword.value = !_obSecurePassword.value;
                    },
                    child: Icon(_obSecurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility)),
              ),
              onChanged: (value) {
                provider.setPassword(value);
              },
            );
          });
    });
  }
}
