/// Get Shimmer
///
/// Public export for the package.
library get_shimmer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';

/// An enum defines all supported directions of shimmer effect
enum ShimmerDirection { ltr, rtl, ttb, btt }

/// Controller that drives shimmer progress using an [AnimationController].
class GetShimmerController extends GetxController implements TickerProvider {
  late final AnimationController controller;
  final RxDouble percent = 0.0.obs;
  final Duration period;
  final int loop;
  int _count = 0;
  final Set<Ticker> _tickers = {};

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

  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = Ticker(onTick, debugLabel: 'GetShimmerController');
    _tickers.add(ticker);
    return ticker;
  }

  void start() => controller.forward();
  void stop() => controller.stop();

  @override
  void onClose() {
    for (final ticker in _tickers) {
      ticker.dispose();
    }
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
      () => _ShimmerRender(
        direction: direction,
        gradient: gradient,
        percent: shimmerController.percent.value,
        child: child,
      ),
    );
  }
}

@immutable
class _ShimmerRender extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _ShimmerRender({
    super.child,
    required this.percent,
    required this.direction,
    required this.gradient,
  });

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  // Shader caching for performance
  Shader? _cachedShader;
  Rect? _cachedRect;
  Gradient? _cachedGradient;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) return;
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) return;
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) return;
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();

      // Cache shader when rect/gradient unchanged for better performance
      if (_cachedRect != rect || _cachedGradient != _gradient) {
        _cachedShader = _gradient.createShader(rect);
        _cachedRect = rect;
        _cachedGradient = _gradient;
      }

      layer!
        ..shader = _cachedShader!
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
