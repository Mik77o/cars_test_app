import 'package:flutter/material.dart';

class TapIcon extends StatelessWidget {
  final Function() onTap;
  final IconData iconData;
  final Color? backgroundColor;
  final Color? color;

  const TapIcon({
    Key? key,
    this.color,
    this.backgroundColor,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(
          height: 36,
          width: 36,
          child: Icon(
            iconData,
            color: color ?? Colors.black45,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
