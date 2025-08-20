import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final onPressed;
  const CustomIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: const Icon(Icons.arrow_forward_ios));
  }
}
