import 'package:flutter/material.dart';

import '../constant/color_constant.dart';

class CustomShimmer extends StatefulWidget {
  final Widget child;

  const CustomShimmer({super.key, required this.child});

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3
              ],
              colors: const [
                ColorConstant.grey300,
                ColorConstant.grey100,
                ColorConstant.grey300,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
