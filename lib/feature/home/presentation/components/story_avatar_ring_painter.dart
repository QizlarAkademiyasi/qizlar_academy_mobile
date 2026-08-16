import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Telegram's intersecting story circles leave the part of each ring facing
/// its neighbour unpainted. This describes one of those excluded arcs.
class StoryRingArcExclusion {
  const StoryRingArcExclusion({
    required this.centerAngle,
    required this.halfSweep,
  });

  final double centerAngle;
  final double halfSweep;
}

class StoryAvatarRingPainter extends CustomPainter {
  const StoryAvatarRingPainter({
    required this.ringColor,
    required this.separatorColor,
    required this.avatarSize,
    required this.collapsedProgress,
    required this.collapseFactor,
    this.exclusions = const [],
  });

  final Color ringColor;
  final Color separatorColor;
  final double avatarSize;
  final double collapsedProgress;
  final double collapseFactor;
  final List<StoryRingArcExclusion> exclusions;

  static const double ringInset = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringRadius = avatarSize / 2 + 2.5 + collapsedProgress * 0.5;

    if (collapsedProgress > 0) {
      canvas.drawCircle(
        center,
        avatarSize / 2 + 3.5,
        Paint()
          ..isAntiAlias = true
          ..color = separatorColor,
      );
    }

    final ringPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2 - 0.35 * collapseFactor
      ..color = ringColor;
    final rect = Rect.fromCircle(center: center, radius: ringRadius);
    final intervals = _normalizedIntervals(exclusions);

    if (intervals.isEmpty) {
      canvas.drawCircle(center, ringRadius, ringPaint);
      return;
    }

    var cursor = 0.0;
    for (final interval in intervals) {
      if (interval.$1 > cursor) {
        canvas.drawArc(rect, cursor, interval.$1 - cursor, false, ringPaint);
      }
      cursor = math.max(cursor, interval.$2);
    }
    if (cursor < math.pi * 2) {
      canvas.drawArc(rect, cursor, math.pi * 2 - cursor, false, ringPaint);
    }
  }

  List<(double, double)> _normalizedIntervals(
    List<StoryRingArcExclusion> source,
  ) {
    const fullTurn = math.pi * 2;
    final intervals = <(double, double)>[];

    for (final exclusion in source) {
      if (exclusion.halfSweep <= 0) continue;
      final center = exclusion.centerAngle % fullTurn;
      final start = center - exclusion.halfSweep;
      final end = center + exclusion.halfSweep;
      if (start < 0) {
        intervals
          ..add((0, end))
          ..add((start + fullTurn, fullTurn));
      } else if (end > fullTurn) {
        intervals
          ..add((start, fullTurn))
          ..add((0, end - fullTurn));
      } else {
        intervals.add((start, end));
      }
    }

    intervals.sort((a, b) => a.$1.compareTo(b.$1));
    if (intervals.length < 2) return intervals;

    final merged = <(double, double)>[intervals.first];
    for (final interval in intervals.skip(1)) {
      final previous = merged.last;
      if (interval.$1 <= previous.$2) {
        merged[merged.length - 1] = (
          previous.$1,
          math.max(previous.$2, interval.$2),
        );
      } else {
        merged.add(interval);
      }
    }
    return merged;
  }

  @override
  bool shouldRepaint(covariant StoryAvatarRingPainter oldDelegate) {
    if (ringColor != oldDelegate.ringColor ||
        separatorColor != oldDelegate.separatorColor ||
        avatarSize != oldDelegate.avatarSize ||
        collapsedProgress != oldDelegate.collapsedProgress ||
        collapseFactor != oldDelegate.collapseFactor ||
        exclusions.length != oldDelegate.exclusions.length) {
      return true;
    }
    for (var index = 0; index < exclusions.length; index++) {
      final current = exclusions[index];
      final old = oldDelegate.exclusions[index];
      if (current.centerAngle != old.centerAngle ||
          current.halfSweep != old.halfSweep) {
        return true;
      }
    }
    return false;
  }
}
