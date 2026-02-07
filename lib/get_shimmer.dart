/// Get Shimmer
///
/// Public export for the package.
library get_shimmer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';

/// An enum defines all supported directions of shimmer effect
enum ShimmerDirection { ltr, rtl, ttb, btt }

/// Controller that drives shimmer progress using an [AnimationController].
class GetShimmerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController controller;
  final RxDouble percent = 0.0.obs;
  final Duration period;
  final int loop;
  int _count = 0;

  GetShimmerController({required this.period, required this.loop}) {
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

/// Public GetShimmer widget. Stateless — animation is controlled by [GetShimmerController]
@immutable
class GetShimmer extends StatelessWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  const GetShimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  });

  /// Convenience constructor that builds a linear gradient from base/highlight colors.
  GetShimmer.fromColors({
    super.key,
    Color? baseColor,
    Color? highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
    required this.child,
  }) : gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            baseColor ?? Colors.grey.shade300,
            baseColor ?? Colors.grey.shade300,
            highlightColor ?? Colors.grey.shade100,
            baseColor ?? Colors.grey.shade300,
            baseColor ?? Colors.grey.shade300,
          ],
          stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
        );

  @override
  Widget build(BuildContext context) {
    // Return child directly when disabled to avoid controller overhead
    if (!enabled) return child;

    // Use a unique tag to allow multiple independent shimmer instances
    final tag = key?.toString() ?? '${identityHashCode(this)}';
    final shimmerController = Get.put(
      GetShimmerController(period: period, loop: loop),
      tag: tag,
    );
    shimmerController.start();

    return Obx(
      () => _ShimmerWidget(
        direction: direction,
        gradient: gradient,
        percent: shimmerController.percent.value,
        child: child,
      ),
    );
  }
}

/// Internal widget that uses Flutter's built-in ShaderMask
class _ShimmerWidget extends StatelessWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;
  final Widget child;

  const _ShimmerWidget({
    required this.percent,
    required this.direction,
    required this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get actual size from constraints or use defaults
        final width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0;
        final height =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 200.0;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final Rect rect;
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
              // ltr
              dx = _offset(-width, width, percent);
              dy = 0.0;
              rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
            }

            return gradient.createShader(rect);
          },
          child: child,
        );
      },
    );
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
