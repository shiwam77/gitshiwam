
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gitshiwam/widget/loading_indicator.dart';


final StreamController<bool> _buttonValueController =
StreamController<bool>.broadcast();

Stream get buttonStream => _buttonValueController.stream;

void setButtonValue({required bool value}) {
  _buttonValueController.add(value);
}

void dispose() {
  _buttonValueController.close();
}


class Button extends StatefulWidget {
  const Button(
      {this.listenToLoadingController = false,
      required this.onTap,
      required this.child,
      this.enabled = true,
      this.trailingIcon,
      this.stretch = true,
      required this.color,
      this.loading = false,
      this.padding = const EdgeInsets.all(16),
      this.elevation = 2,
      this.borderRadius = 10,
      this.leadingIcon,
      this.loadingWidget,
      Key? key})
      : super(key: key);
  final bool listenToLoadingController;
  final VoidCallback? onTap;
  final Color? color;
  final bool enabled;
  final Widget child;
  final Icon? leadingIcon;
  final Icon? trailingIcon;
  final double borderRadius;
  final Widget? loadingWidget;
  final bool stretch;
  final bool loading;
  final double elevation;
  final EdgeInsets padding;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool loading = false;
  @override
  void initState() {
    if (widget.listenToLoadingController) {
      buttonStream.listen((onData) {
        if (mounted) {
          setState(() {
            if (onData != null) {
              loading = onData;
            } else {
              loading = false;
            }
          });
        }
      });
    } else {
      loading = widget.loading;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    setState(() {
      loading = widget.loading;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: widget.color,
      elevation: widget.elevation,
      padding: widget.padding,

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      onPressed: widget.enabled && !loading ? widget.onTap : null,
      color: widget.color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          !loading
              ? Row(
                  mainAxisSize:
                      widget.stretch ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: widget.leadingIcon != null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: widget.leadingIcon ?? Container(),
                        )),
                    Flexible(child: widget.child),
                    Visibility(
                        visible: widget.trailingIcon != null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: widget.trailingIcon ?? Container(),
                        )),
                  ],
                )
              : Row(
                  mainAxisSize:
                      widget.stretch ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: widget.loadingWidget != null,
                        child: widget.loadingWidget ?? Container()),
                    const LoadingIndicator(),
                  ],
                ),
        ],
      ),
    );
  }
}

class StringButton extends StatelessWidget {
  const StringButton(
      {this.listenToLoadingController = false,
      required this.onTap,
      required this.title,
      this.loading = false,
      this.enabled = true,
      this.stretch = true,
      this.trailingIcon,
      this.color,
      this.subtitle,
      this.elevation = 2,
      this.borderRadius = 10,
      this.textSize,
      this.leadingIcon,
      this.padding = const EdgeInsets.all(16),
      this.loadingText,
      Key? key})
      : super(key: key);
  final bool listenToLoadingController;
  final VoidCallback? onTap;
  final Color? color;
  final bool enabled;
  final double? textSize;
  final String? title;
  final String? subtitle;
  final Icon? leadingIcon;
  final double borderRadius;
  final String? loadingText;
  final Icon? trailingIcon;
  final bool loading;
  final bool stretch;
  final double elevation;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: onTap,
      trailingIcon: trailingIcon,
      loadingWidget: Text(loadingText ?? '',
          style:
              Theme.of(context).textTheme.button!.copyWith(fontSize: textSize)),
      color: color,
      borderRadius: borderRadius,
      leadingIcon: leadingIcon,
      enabled: enabled,
      elevation: elevation,
      loading: loading,
      stretch: stretch,
      listenToLoadingController: listenToLoadingController,
      child: Column(
        children: [
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: textSize),
          ),
          Visibility(
              visible: subtitle != null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(subtitle ?? ''),
              )),
        ],
      ),
    );
  }
}
