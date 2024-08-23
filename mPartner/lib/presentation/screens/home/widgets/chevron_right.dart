import 'package:flutter/material.dart';

class ChevronRightWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  const ChevronRightWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Icon(Icons.chevron_right),
      ),
    );
  }
}
