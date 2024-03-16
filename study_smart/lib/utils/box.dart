import 'package:flutter/material.dart';

class CustomBox extends StatefulWidget {
  const CustomBox({
  Key? key, 
  required this.color, 
  required this.height,
  required this.width,
  required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;
  final double height;
  final double width;

  @override
  State<CustomBox> createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: widget.color,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: widget.child,
        )
      ),
    );
  }
}


class ButtonBox extends StatefulWidget {
  const ButtonBox({
    Key? key, 
    required this.color, 
    required this.width,
    required this.icon,
    required this.text,
    required this.onTap
  }) : super(key: key);

  final Color color;
  final Icon icon;
  final double width;
  final String text;
  final Function() onTap;

  @override
  State<ButtonBox> createState() => _ButtonBoxState();
}

class _ButtonBoxState extends State<ButtonBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              child: Row(
                children: [
                  widget.icon,
                  const SizedBox(width: 10),
                  Text(
                    widget.text
                  )
                ],
              ),
            )
          )
        ),
      ),
    );
  }
}