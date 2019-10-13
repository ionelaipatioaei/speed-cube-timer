import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String _src;
  final String _alt;
  final double _size;
  final Color color;
  SvgIcon(this._src, this._alt, this._size, {this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_src, semanticsLabel: _alt, height: _size, width: _size, color: color ?? Colors.white);
  }
}