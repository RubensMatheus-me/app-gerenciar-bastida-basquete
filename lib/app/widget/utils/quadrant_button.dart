import 'package:flutter/material.dart';
import 'package:datahoops/app/domain/enums/enum_quadrant_position.dart'; 

class _QuadrantClipper extends CustomClipper<Path> {
  final QuadrantPosition position;
  _QuadrantClipper(this.position);

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double radius = size.width < size.height ? size.width : size.height;

    switch (position) {
      case QuadrantPosition.topLeft:
        path..moveTo(0, radius)
            ..arcToPoint(Offset(radius, 0),
                radius: Radius.circular(radius), clockwise: false)
            ..lineTo(0, 0)
            ..close();
        break;
      case QuadrantPosition.topRight:
        path..moveTo(size.width - radius, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width, radius)
            ..arcToPoint(Offset(size.width - radius, 0),
                radius: Radius.circular(radius), clockwise: true)
            ..close();
        break;
      case QuadrantPosition.bottomLeft:
        path..moveTo(0, size.height - radius)
            ..lineTo(0, size.height)
            ..lineTo(radius, size.height)
            ..arcToPoint(Offset(0, size.height - radius),
                radius: Radius.circular(radius), clockwise: true)
            ..close();
        break;
      case QuadrantPosition.bottomRight:
        path..moveTo(size.width, size.height - radius)
            ..lineTo(size.width, size.height)
            ..lineTo(size.width - radius, size.height)
            ..arcToPoint(Offset(size.width, size.height - radius),
                radius: Radius.circular(radius), clockwise: false)
            ..close();
        break;
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) =>
      old is _QuadrantClipper && old.position != position;
}

class QuadrantButton extends StatelessWidget {
  final VoidCallback onPressed;
  final QuadrantPosition position;
  final Color color;
  final Widget? child;
  final double size;

  const QuadrantButton({
    super.key,
    required this.onPressed,
    required this.position,
    this.color = Colors.blue,
    this.child,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: ClipPath(
          clipper: _QuadrantClipper(position),
          child: Material(
            color: color,
            child: InkWell(onTap: onPressed, child: Center(child: child)),
          ),
        ),
      );
}
