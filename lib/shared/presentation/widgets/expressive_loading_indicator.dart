import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// An uncontained Material 3 expressive-style loading indicator.
///
/// This widget renders a morphing superellipse shape that smoothly transitions
/// by varying the superellipse exponent over time, creating an expressive
/// morphing animation without additional dependencies.
class ExpressiveLoadingIndicator extends StatefulWidget {
  /// The width and height of the indicator.
  final double? size;

  /// Fill color for the indicator. Defaults to theme primary color.
  final Color? color;

  /// Optional semantics label for accessibility.
  final String? semanticsLabel;

  const ExpressiveLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
  });

  @override
  State<ExpressiveLoadingIndicator> createState() =>
      _ExpressiveLoadingIndicatorState();
}

class _ExpressiveLoadingIndicatorState extends State<ExpressiveLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t; // 0..1 looping

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: UIConstants.expressiveIndicatorAnimationDuration,
    )..repeat();
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size ?? UIConstants.expressiveIndicatorSizeMd;
    final Color color = widget.color ?? Theme.of(context).colorScheme.primary;
    final String semantics = widget.semanticsLabel ?? AppStrings.loading;

    return Semantics(
      label: semantics,
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedBuilder(
          animation: _t,
          builder: (context, _) {
            return CustomPaint(
              painter: _ExpressivePainter(progress: _t.value, color: color),
            );
          },
        ),
      ),
    );
  }
}

/// Paints a morphing superellipse that varies its exponent over time.
class _ExpressivePainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;

  _ExpressivePainter({required this.progress, required this.color});

  static const int _pointCount = 120; // smooth curve resolution

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    // Morph cycle through multiple exponents to emulate expressive shapes.
    // Exponent 2 ~ circle, higher exponents ~ more squarish/squircular.
    // We create a triangle-wave over [2, 7, 3.5, 10] for variety.
    final List<double> exponents = [2.0, 7.0, 3.5, 10.0];
    final double segment = 1.0 / exponents.length;
    final int idx = (progress / segment).floor().clamp(0, exponents.length - 1);
    final int nextIdx = (idx + 1) % exponents.length;
    final double localT = (progress - idx * segment) / segment;
    final double n = _lerp(
      exponents[idx],
      exponents[nextIdx],
      _easeInOut(localT),
    );

    final Path path = _buildSuperellipsePath(size, n);
    canvas.drawPath(path, paint);
  }

  Path _buildSuperellipsePath(Size size, double n) {
    // Centered in the available size, use half-size as radius baseline.
    final double rx = size.width / 2.0;
    final double ry = size.height / 2.0;
    final Offset center = Offset(rx, ry);

    // Generate parametric superellipse using angle parameterization.
    // |x/a|^n + |y/b|^n = 1
    // Param: x = a * sign(cos t) * |cos t|^(2/n)
    //        y = b * sign(sin t) * |sin t|^(2/n)
    final Path path = Path();
    for (int i = 0; i <= _pointCount; i++) {
      final double t = (i / _pointCount) * 2.0 * math.pi;
      final double ct = math.cos(t);
      final double st = math.sin(t);
      final double exponent = 2.0 / n;
      final double x = rx * _sign(ct) * math.pow(ct.abs(), exponent).toDouble();
      final double y = ry * _sign(st) * math.pow(st.abs(), exponent).toDouble();
      final Offset p = center + Offset(x, y);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  double _sign(double v) => v >= 0 ? 1.0 : -1.0;

  double _easeInOut(double t) {
    return Curves.easeInOut.transform(t.clamp(0.0, 1.0));
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _ExpressivePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
