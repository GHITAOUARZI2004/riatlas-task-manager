import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const ConfettiOverlay({super.key, required this.onComplete});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Stack(
        children: List.generate(30, (index) {
          final random = index * 137.5;
          final left = (random % size.width);
          final color = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            Colors.teal,
            Colors.pink,
          ][index % 8];

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _controller.value;
              final y = -50 + (size.height + 100) * progress * (0.5 + (index % 3) * 0.25);
              final rotation = progress * 4 * 3.14159 * (index % 2 == 0 ? 1 : -1);
              final opacity = progress < 0.8 ? 1.0 : 1.0 - (progress - 0.8) * 5;

              return Positioned(
                left: left,
                top: y,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Container(
                      width: 8 + (index % 4) * 3,
                      height: 8 + (index % 4) * 3,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(index % 3 == 0 ? 4 : 0),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
