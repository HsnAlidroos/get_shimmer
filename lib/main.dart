import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

class ShimmerController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController controller;
  RxDouble percent = 0.0.obs;
  final Duration period;
  final int loop;
  int _count = 0;

  ShimmerController({required this.period, required this.loop}) {
    controller = AnimationController(vsync: this, duration: period)
      ..addListener(() => percent.value = controller.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _count++;
          if (loop <= 0) {
            controller.repeat();
          } else if (_count < loop) {
            controller.forward(from: 0.0);
          }
        }
      });
  }

  void start() => controller.forward();
  void stop() => controller.stop();

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

class Shimmer extends StatelessWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerController = Get.put(ShimmerController(period: period, loop: loop));
    if (enabled) shimmerController.start();

    return Obx(() => _Shimmer(
      direction: direction,
      gradient: gradient,
      percent: shimmerController.percent.value,
      child: child,
    ));
  }
}

class _Shimmer extends StatelessWidget {
  final Widget child;
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _Shimmer({
    required this.child,
    required this.percent,
    required this.direction,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        final width = bounds.width;
        final height = bounds.height;
        Rect rect;
        double dx, dy;

        if (direction == ShimmerDirection.rtl) {
          dx = _offset(width, -width, percent);
          dy = 0.0;
          rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
        } else if (direction == ShimmerDirection.ttb) {
          dx = 0.0;
          dy = _offset(-height, height, percent);
          rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
        } else if (direction == ShimmerDirection.btt) {
          dx = 0.0;
          dy = _offset(height, -height, percent);
          rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
        } else {
          dx = _offset(-width, width, percent);
          dy = 0.0;
          rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
        }

        return gradient.createShader(rect);
      },
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
