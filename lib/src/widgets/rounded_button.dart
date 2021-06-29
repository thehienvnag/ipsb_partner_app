import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  final Color? color;
  final double radius;

  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.radius = 25,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        child: Material(
          color: color,
          child: InkWell(
            splashColor: Colors.grey.withOpacity(0.5),
            onTap: onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
