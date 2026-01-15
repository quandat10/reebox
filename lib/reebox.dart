import 'package:flutter/material.dart';

enum ShadowMode {
  v1,
  v2,
}

class ReeButton extends StatefulWidget {
  final Widget child;
  final Color? outlineColor;
  final Color? primaryColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final double strokeWidth;
  final Function()? onClick;
  final EdgeInsetsGeometry? padding;
  final bool disable;
  final bool loading;
  final ShadowMode shadowMode;
  final bool isCenter;

  const ReeButton({
    super.key,
    required this.child,
    this.height,
    this.outlineColor = Colors.black,
    this.primaryColor = Colors.white,
    this.strokeWidth = 2,
    this.borderColor = Colors.black,
    this.onClick,
    this.borderRadius = 8,
    this.padding,
    this.width,
    this.disable = false,
    this.loading = false,
    this.shadowMode = ShadowMode.v1,
    this.isCenter = true,
  });

  @override
  State<ReeButton> createState() => _BoxState();
}

class _BoxState extends State<ReeButton> {
  bool isTouched = false;
  bool isProcessing = false;
  EdgeInsetsGeometry marginTapBottomV1 = const EdgeInsets.only(top: 3);
  EdgeInsetsGeometry marginTapBottomV2 = const EdgeInsets.only(top: 3, left: 3);
  EdgeInsetsGeometry marginTapTopV1 = const EdgeInsets.only(bottom: 3);
  EdgeInsetsGeometry marginTapTopV2 =
  const EdgeInsets.only(bottom: 3, right: 3);
  late EdgeInsetsGeometry marginDefault = widget.shadowMode == ShadowMode.v1
      ? const EdgeInsets.only(bottom: 3)
      : const EdgeInsets.only(bottom: 3, right: 3);

  EdgeInsetsGeometry animatedPositionBottom(bool isTouch) {
    if (isTouch) {
      if (widget.shadowMode == ShadowMode.v1) {
        return marginTapBottomV1;
      }
      return marginTapBottomV2;
    }

    return marginDefault;
  }

  EdgeInsetsGeometry animatedPositionTop(bool isTouch) {
    if (isTouch) {
      if (widget.shadowMode == ShadowMode.v1) {
        return marginTapTopV1;
      }

      return marginTapTopV2;
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

    final effectivePrimaryColor = widget.disable
        ? Colors.grey[300]
        : (widget.primaryColor ?? Colors.white);
    final effectiveOutlineColor = widget.disable
        ? Colors.grey[400]
        : (widget.outlineColor ?? Colors.black54);
    final borderColor = widget.borderColor ?? Colors.black;
    final effectiveBorderColor = widget.disable ? Colors.grey : borderColor;

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
        onTap: widget.disable || widget.loading ? null : widget.onClick,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Stack(
              children: [
                AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  margin: widget.shadowMode == ShadowMode.v1
                      ? EdgeInsets.only(top: 3)
                      : EdgeInsets.only(top: 3, left: 3),
                  alignment: Alignment.bottomRight,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: effectiveOutlineColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      width: widget.strokeWidth,
                      color: effectiveBorderColor,
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  margin: widget.onClick == null ? marginDefault : animatedPositionBottom(isTouched),
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    alignment: widget.isCenter ? Alignment.center : null,
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
