import 'package:flutter/material.dart';

class ReeButton extends StatefulWidget {
  final Widget child;
  final Color? outlineColor;
  final Color? primaryColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final double strokeWidth;
  final Function()? onClick;
  final EdgeInsetsGeometry? padding;
  final bool disable;
  final bool loading;

  const ReeButton({
    super.key,
    required this.child,
    this.height,
    this.outlineColor = Colors.black,
    this.primaryColor = Colors.white,
    this.strokeWidth = 1,
    this.onClick,
    this.borderRadius = 8,
    this.padding,
    this.width,
    this.disable = false,
    this.loading = false,
  });

  @override
  State<ReeButton> createState() => _BoxState();
}

class _BoxState extends State<ReeButton> {
  bool isTouched = false;
  bool isProcessing = false;
  EdgeInsetsGeometry marginTapBottom = const EdgeInsets.only(top: 3);
  EdgeInsetsGeometry marginDefault =
  EdgeInsets.only(bottom: 3);

  EdgeInsetsGeometry animatedPositionBottom(bool isTouch) {
    if (isTouch) {
      return marginTapBottom;
    }

    return marginDefault;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.loading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          widget.child,
        ],
      );
    }

    final effectivePrimaryColor = widget.disable ? Colors.grey[300] : (widget.primaryColor ?? Colors.white);
    final effectiveOutlineColor = widget.disable ? Colors.grey[400] : (widget.outlineColor ?? Colors.black54);
    final effectiveBorderColor = widget.disable ? Colors.grey : Colors.black87;

    return Listener(
      onPointerDown: (a) {
        if (!widget.disable && !widget.loading) {
          setState(() {
            isTouched = true;
          });
        }
      },
      onPointerUp: (a) {
        if (!widget.disable && !widget.loading) {
          setState(() {
            isTouched = false;
          });
        }
      },
      child: InkWell(
        onTap: widget.disable || widget.loading
            ? null
            : widget.onClick,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Stack(
              children: [
                AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  margin: EdgeInsets.only(top: 3),
                  alignment: Alignment.bottomRight,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: effectiveOutlineColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
                AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  margin: animatedPositionBottom(isTouched),
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    alignment: Alignment.center,
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    decoration: BoxDecoration(
                      color: effectivePrimaryColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        width: widget.strokeWidth,
                        color: effectiveBorderColor,
                      ),
                    ),
                    child: content,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}