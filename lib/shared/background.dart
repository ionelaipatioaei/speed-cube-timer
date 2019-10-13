import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  static const gradients = ["assets/gradients/mesh/gradient4.jpg", "assets/gradients/mesh/gradient13.jpg"];

  final List<Color> _gradient;
  final int _meshIndex;

  final Widget child;

  Background(this._gradient, this._meshIndex, {this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(gradients[_meshIndex]),
          fit: BoxFit.fill
        ),
      ),
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: _gradient
          )
        ),
        child: child,
      )
    );
  }
}