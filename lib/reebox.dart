library reebox;

import 'package:flutter/material.dart';

class ReeBox extends StatefulWidget {
  final Widget children;
  final Color? outlineColor;
  final double height;
  final double width;
  final double strokeWidth;
  final bool isCenter;
  final Function()? onClick;
  const ReeBox(
      {super.key,
      required this.children,
      required this.height,
      this.outlineColor = Colors.blue,
      this.strokeWidth = 1,
      this.onClick,
      this.isCenter = false,
      required this.width});

  @override
  State<ReeBox> createState() => _BoxState();
}

class _BoxState extends State<ReeBox> {
  bool isTouched = false;
  EdgeInsetsGeometry marginTapTop = const EdgeInsets.only(bottom: 6, right: 6);
  EdgeInsetsGeometry marginDefault =
      const EdgeInsets.only(bottom: 3, right: 3, top: 3, left: 3);
  EdgeInsetsGeometry marginTapBottom = const EdgeInsets.only(top: 6, left: 6);

  EdgeInsetsGeometry animatedPositionBottom(bool isTouch) {
    if (isTouch) {
      return marginTapBottom;
    }

    return marginDefault;
  }

  EdgeInsetsGeometry animatedPositionTop(bool isTouch) {
    if (isTouch) {
      return marginTapTop;
    }

    return marginDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (a) {
        setState(() {
          isTouched = true;
        });
      },
      onPointerUp: (a) {
        setState(() {
          isTouched = false;
        });
      },
      child: InkWell(
        onTap: widget.onClick,
        child: Stack(
          children: [
            AnimatedContainer(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.bottomRight,
              margin: animatedPositionBottom(isTouched),
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.outlineColor,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(width: widget.strokeWidth, color: Colors.black),
              ),
            ),
            AnimatedContainer(
              width: widget.width,
              height: widget.height,
              margin: animatedPositionTop(isTouched),
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: widget.strokeWidth, color: Colors.black),
                ),
                child: widget.isCenter
                    ? Center(
                        child: widget.children,
                      )
                    : widget.children,
              ),
            )
          ],
        ),
      ),
    );
  }
}
