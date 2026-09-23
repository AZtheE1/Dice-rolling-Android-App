import 'dart:math';
import 'package:flutter/material.dart';

/// A standalone, high-performance procedural 2D/3D-shaded dice widget
/// that animates without relying on external .json or bitmap assets.
class ProceduralDice extends StatefulWidget {
  final int value;
  final bool isRolling;
  final double size;
  final Color diceColor;
  final Color dotColor;
  final VoidCallback? onTap;

  const ProceduralDice({
    super.key,
    required this.value,
    this.isRolling = false,
    this.size = 120.0,
    this.diceColor = Colors.white,
    this.dotColor = const Color(0xFF1E293B),
    this.onTap,
  });

  @override
  State<ProceduralDice> createState() => _ProceduralDiceState();
}

class _ProceduralDiceState extends State<ProceduralDice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnim;
  late Animation<double> _scaleAnim;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _rotationAnim = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(ProceduralDice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isRolling ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final isAnimating = _controller.isAnimating;
          final angle = isAnimating
              ? _rotationAnim.value + (_rng.nextDouble() * 0.2 - 0.1)
              : 0.0;
          final scale = isAnimating ? _scaleAnim.value : 1.0;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // Perspective effect
              ..scaleByDouble(scale, scale, 1.0, 1.0)
              ..rotateZ(angle)
              ..rotateX(isAnimating ? sin(angle) * 0.35 : 0.0)
              ..rotateY(isAnimating ? cos(angle) * 0.35 : 0.0),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.diceColor,
                borderRadius: BorderRadius.circular(widget.size * 0.22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFE2E8F0),
                    Color(0xFFCBD5E1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    offset: const Offset(0, 10),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    offset: const Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _DiceFacePainter(
                  value: widget.value,
                  dotColor: widget.dotColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DiceFacePainter extends CustomPainter {
  final int value;
  final Color dotColor;

  _DiceFacePainter({required this.value, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = (value == 1) ? const Color(0xFFEF4444) : dotColor
      ..style = PaintingStyle.fill;

    final dotRadius = size.width * 0.095;
    final left = size.width * 0.26;
    final center = size.width * 0.50;
    final right = size.width * 0.74;

    final top = size.height * 0.26;
    final middle = size.height * 0.50;
    final bottom = size.height * 0.74;

    void drawDot(double x, double y) {
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      // Subtle inner depth on dots
      final innerShadow = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(x, y), dotRadius - 0.5, innerShadow);
    }

    switch (value.clamp(1, 6)) {
      case 1:
        drawDot(center, middle);
        break;
      case 2:
        drawDot(left, top);
        drawDot(right, bottom);
        break;
      case 3:
        drawDot(left, top);
        drawDot(center, middle);
        drawDot(right, bottom);
        break;
      case 4:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 5:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(center, middle);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 6:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, middle);
        drawDot(right, middle);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _DiceFacePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.dotColor != dotColor;
  }
}
