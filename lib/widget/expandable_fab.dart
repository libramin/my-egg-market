import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

const Duration _duration = Duration(milliseconds: 300);

class ExpandableFab extends StatefulWidget {
  const ExpandableFab(
      {Key? key, required this.distance, required this.children})
      : super(key: key);

  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  bool _open = false;
  late AnimationController _animationController;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, value: _open ? 1.0 : 0.0, duration: _duration,);
    _expandAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // _buildtabToCloseFab(),
          _buildtabToOpenFab(),
        ]..insertAll(0,_buildExpandableActionButton()),
      ),
    );
  }

  List<_ExpandableActionButton> _buildExpandableActionButton() {
    List<_ExpandableActionButton> animChildren = [];
    final count = widget.children.length;
    final step = 90 / (count - 1);

    for (var i = 0, degree = 0.0; i < count; i++, degree += step) {
      animChildren.add(_ExpandableActionButton(
          distance: widget.distance, progress: _expandAnimation!,
          degree: degree,
          child: widget.children[i]));
    }
    return animChildren;
  }

AnimatedContainer _buildtabToOpenFab() {
  return AnimatedContainer(duration: _duration,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(_open ? pi / 4 : 0),
      child: FloatingActionButton(
        onPressed: toggle, child: Icon(Icons.add),
      backgroundColor: _open? Colors.white:Theme.of(context).primaryColor,));
}

// AnimatedContainer _buildtabToCloseFab() {
//   return AnimatedContainer(duration: _duration,
//       transformAlignment: Alignment.center,
//       transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
//       child: AnimatedOpacity(opacity: _open ? 0.0 : 1.0,
//           duration: Duration(seconds: 1),
//           child: FloatingActionButton(onPressed: toggle,
//             child: Icon(Icons.home, color: Colors.black87,))));
// }


void toggle() {
  _open = !_open;
  setState(() {
    if (_open) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  });
}

}


class _ExpandableActionButton extends StatelessWidget {
  const _ExpandableActionButton(
      {Key? key, required this.distance, required this.degree, required this.progress, required this.child})
      : super(key: key);

  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(builder: (BuildContext context, Widget? child) {
      final Offset offset = Offset.fromDirection(
          degree * (pi / 180), progress.value * distance);
      return Positioned(
        child: child!, right: offset.dx -16, bottom: offset.dy);
    },
        animation: progress,
        child: child);
  }
}
