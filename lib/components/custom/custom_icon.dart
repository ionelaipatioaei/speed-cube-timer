import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final String src;
  final String alt;
  final double size;
  final Color color;
  CustomIcon(this.src, this.alt, this.size, {this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(src, semanticsLabel: alt, height: size, width: size, color: color ?? Colors.white);
  }
}