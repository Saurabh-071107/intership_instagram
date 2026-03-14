import 'package:flutter/material.dart';
class ZoomOverlay extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final double minScale;
  final double maxScale;

  const ZoomOverlay({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.minScale = 1.0,
    this.maxScale = 5.0,
  });

  @override
  State<ZoomOverlay> createState() => _ZoomOverlayState();
}

class _ZoomOverlayState extends State<ZoomOverlay> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  Offset _initialTouchPoint = Offset.zero;
  Offset _currentOffset = Offset.zero;
  double _currentScale = 1.0;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
          vsync: this,
          duration: widget.animationDuration,
        );
    
    _animationController.addListener(() {
      if (_overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _createOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final double activeScale = _animationController.isAnimating ? _scaleAnimation.value : _currentScale;
        final Offset activeOffset = _animationController.isAnimating ? _offsetAnimation.value : _currentOffset;

        return Material(
          color: Colors.black.withValues(alpha: 0.0),
          child: Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..translate(activeOffset.dx, activeOffset.dy)
                    ..scale(activeScale),
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (details.pointerCount < 2) return;

    _animationController.stop();
    _initialTouchPoint = details.focalPoint;
    _createOverlay(context);
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_overlayEntry == null) return;

    setState(() {
      _currentScale = details.scale.clamp(widget.minScale, widget.maxScale);

      _currentOffset = details.focalPoint - _initialTouchPoint;
    });
    
    _overlayEntry!.markNeedsBuild();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_overlayEntry == null) return;

    _scaleAnimation = Tween<double>(begin: _currentScale, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _offsetAnimation = Tween<Offset>(begin: _currentOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward(from: 0).whenComplete(() {
      _removeOverlay();
      setState(() {
        _currentScale = 1.0;
        _currentOffset = Offset.zero;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: Opacity(
        opacity: _overlayEntry != null ? 0.0 : 1.0,
        child: widget.child,
      ),
    );
  }
}
