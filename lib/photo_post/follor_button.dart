import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            'Follow',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class OpacityButton extends StatefulWidget {
  const OpacityButton(
      {super.key, void Function()? onPressed, required Widget child})
      : _child = child,
        _onPressed = onPressed;

  final Widget _child;
  final void Function()? _onPressed;

  @override
  State<OpacityButton> createState() => _OpacityButtonState();
}

class _OpacityButtonState extends State<OpacityButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget._onPressed,
      onTapCancel: () => _controller.reverse(),
      onTapUp: (_) => _controller.reverse(),
      onTapDown: (details) => _controller.forward(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) =>
            Opacity(opacity: _opacity.value, child: widget._child),
        child: widget._child,
      ),
    );
  }
}
