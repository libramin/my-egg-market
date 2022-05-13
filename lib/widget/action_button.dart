import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange[300],
        shape: CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: IconButton(onPressed: (){}, icon: icon,));
  }
}
