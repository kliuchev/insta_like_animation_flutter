import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_like_animation_flutter/double_tap_detector.dart';
import 'package:insta_like_animation_flutter/photo_post/heart.dart';

class LikeSurface extends StatelessWidget {
  const LikeSurface({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DoubleTapDetector(
      onDoubleTap: (details) {
        final overlay = Overlay.of(context);
        _addNewHeart(overlay, details.globalPosition);
      },
      child: child,
    );
  }

  void _addNewHeart(OverlayState overlay, Offset position) {
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return PhotoLike(
          position: position,
          entry: entry,
        );
      },
    );
    overlay.insert(entry);
  }
}

class PhotoLike extends StatefulWidget {
  const PhotoLike({
    super.key,
    required Offset position,
    required OverlayEntry entry,
    Size size = const Size(80, 80),
  })  : _position = position,
        _size = size,
        _entry = entry;

  final Offset _position;
  final Size _size;
  final OverlayEntry _entry;

  @override
  State<PhotoLike> createState() => _PhotoLikeState();
}

class _PhotoLikeState extends State<PhotoLike>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 1000);
  static const secondIntervalStart = 0.55;

  late AnimationController _controller;

  late Animation<double> _topOffset;
  late Animation<double> _leftOffset;
  late Animation<double> _inOpacity;
  late Animation<double> _angle;
  late Animation<double> _inScale;
  late Animation<double> _outOpacity;
  late Animation<double> _outScale;
  late Tween<double> _leftOffsetTween;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget._entry.remove();
      }
    });
    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Create intervals for the animations
  Interval _createFirstInterval([Curve curve = Curves.easeInBack]) =>
      Interval(0.0, 0.5, curve: curve);

  Interval _createSecondInterval([Curve curve = Curves.easeOut]) =>
      Interval(secondIntervalStart, 1.0, curve: curve);

  /// Setup the animation controller and the animations
  /// The heart will be animated in two intervals:
  /// 1. The heart will appear on the screen
  /// 2. The heart will disappear from the screen
  /// The first interval will last from 0 to 0.5
  /// The second interval will last from 0.55 to 1
  /// The heart will be animated in the following way:
  /// 1. The heart will scale from 0.5 to 1
  /// 2. The heart will move from the initial position to the top of the screen
  /// 3. The heart will scale from 1 to 1.2
  /// 4. The heart will fade out
  /// 5. The heart will rotate from a random angle to 0
  /// 6. The heart will be removed from the screen
  void _setupAnimation() {
    /// Randomize the start angle of the heart
    final double startAngle = Random.secure().nextDouble() - 0.5;

    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    /// The angle of the heart is animated from the start angle to 0
    _angle = Tween<double>(begin: startAngle, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: _createFirstInterval()));

    /// The heart scale is animated from 0.5 to 1 in the first interval
    _inScale = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: _createFirstInterval()));

    /// The heart opacity is animated from 0 to 1 in the first interval
    _inOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller, curve: _createFirstInterval(Curves.linear)));

    _leftOffsetTween = Tween<double>(
      begin: widget._position.dx - widget._size.width / 2,
      end: widget._position.dx - widget._size.width / 2,
    );

    _leftOffset = _leftOffsetTween.animate(
        CurvedAnimation(parent: _controller, curve: _createSecondInterval()));

    /// The heart top offset is animated from the initial position to -height
    /// in the second interval
    /// This will make the heart disappear from the screen
    _topOffset = Tween<double>(
      begin: widget._position.dy - widget._size.height / 2,
      end: -widget._size.height,
    ).animate(
        CurvedAnimation(parent: _controller, curve: _createSecondInterval()));

    /// The heart opacity is animated from 1 to 0.3 in the second interval
    _outOpacity = Tween<double>(begin: 1, end: 0.3).animate(CurvedAnimation(
        parent: _controller, curve: _createSecondInterval(Curves.linear)));

    /// The heart scale is animated from 1 to 1.2 in the second interval
    _outScale = Tween<double>(begin: 1, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: _createSecondInterval()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenWidth = MediaQuery.of(context).size.width;
    final double endLeftOffset =
        (screenWidth / 2.0) + (Random.secure().nextDouble() * 60 - 30);

    _leftOffsetTween.end = endLeftOffset;
  }

  double get _opacity => _controller.value <= secondIntervalStart
      ? _inOpacity.value
      : _outOpacity.value;

  double get _width =>
      widget._size.width *
      (_controller.value <= secondIntervalStart
          ? _inScale.value
          : _outScale.value);

  double get _height =>
      widget._size.height *
      (_controller.value < secondIntervalStart
          ? _inScale.value
          : _outScale.value);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) => Positioned(
          top: _topOffset.value,
          left: _leftOffset.value,
          child: SizedBox(
            width: widget._size.width,
            height: widget._size.height,
            child: Center(
              child: Transform.rotate(
                angle: _angle.value,
                child: Opacity(
                  opacity: _opacity,
                  child: SizedBox(
                    width: _width,
                    height: _height,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Heart.gradient(size: widget._size),
      );
}
