import 'package:flutter/material.dart';

/// Loading indicator size options
enum AppLoadingSize {
  small,
  medium,
  large,
}

/// AppLoading - Atomic design system loading indicator component
///
/// Provides consistent loading states across the app with theme integration.
///
/// Example:
/// ```dart
/// AppLoading.circular()
/// AppLoading.linear()
/// AppLoading.skeleton(width: 200, height: 20)
/// ```
class AppLoading extends StatelessWidget {
  final AppLoadingSize size;
  final Color? color;

  const AppLoading({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
  });

  /// Circular progress indicator
  const AppLoading.circular({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
  });

  /// Small circular indicator
  const AppLoading.small({
    super.key,
    this.color,
  }) : size = AppLoadingSize.small;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double indicatorSize = _getIndicatorSize();

    return Center(
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: _getStrokeWidth(),
          color: color ?? colorScheme.primary,
        ),
      ),
    );
  }

  double _getIndicatorSize() {
    switch (size) {
      case AppLoadingSize.small:
        return 20;
      case AppLoadingSize.medium:
        return 32;
      case AppLoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoadingSize.small:
        return 2;
      case AppLoadingSize.medium:
        return 3;
      case AppLoadingSize.large:
        return 4;
    }
  }
}

/// Linear progress indicator
class AppLinearLoading extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const AppLinearLoading({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: value,
          color: color ?? colorScheme.primary,
          backgroundColor:
              backgroundColor ?? colorScheme.primary.withOpacity(0.2),
        ),
      ),
    );
  }
}

/// Skeleton loading placeholder with shimmer animation
class AppSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isCircle;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
  });

  /// Rectangular skeleton
  const AppSkeleton.rect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : isCircle = false;

  /// Circular skeleton (avatar, profile picture)
  const AppSkeleton.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        isCircle = true;

  /// Line skeleton for text placeholders
  const AppSkeleton.line({
    super.key,
    this.width,
    double height = 16,
  })  : height = height,
        borderRadius = null,
        isCircle = false;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    final effectiveBorderRadius = widget.isCircle
        ? BorderRadius.circular((widget.width ?? 40) / 2)
        : widget.borderRadius ?? BorderRadius.circular(8);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
            ),
            borderRadius: effectiveBorderRadius,
          ),
        );
      },
    );
  }
}

/// Loading overlay that covers the entire screen
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ??
                Theme.of(context).colorScheme.scrim.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLoading(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Skeleton text block for multi-line text placeholders
class SkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double? lastLineWidth;

  const SkeletonText({
    super.key,
    this.lines = 3,
    this.lineHeight = 16,
    this.lastLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) {
          final isLastLine = index == lines - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: index < lines - 1 ? 8 : 0),
            child: AppSkeleton.line(
              width: isLastLine && lastLineWidth != null
                  ? lastLineWidth
                  : double.infinity,
              height: lineHeight,
            ),
          );
        },
      ),
    );
  }
}

/// Card skeleton placeholder
class SkeletonCard extends StatelessWidget {
  final double? height;
  final bool showImage;
  final bool showTitle;
  final bool showSubtitle;

  const SkeletonCard({
    super.key,
    this.height,
    this.showImage = true,
    this.showTitle = true,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage) ...[
            const AppSkeleton.rect(
              width: double.infinity,
              height: 150,
            ),
            const SizedBox(height: 12),
          ],
          if (showTitle) ...[
            const AppSkeleton.line(
              width: 200,
              height: 20,
            ),
            const SizedBox(height: 8),
          ],
          if (showSubtitle) ...[
            const AppSkeleton.line(
              width: 150,
              height: 16,
            ),
          ],
        ],
      ),
    );
  }
}
