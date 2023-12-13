import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final bool loading;
  final bool isEnabled;
  final Widget child;
  final bool isScreenHidden;
  final Color? bgColor;
  final Color? loadingColor;
  final AlignmentGeometry alignment;
  final double? marginTop;
  const LoadingWidget({
    Key? key,
    this.loading = false,
    this.isEnabled = true,
    required this.child,
    this.isScreenHidden = false,
    this.bgColor,
    this.loadingColor,
    this.alignment = Alignment.center,
    this.marginTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        if (!isScreenHidden)
          AbsorbPointer(
            absorbing: loading,
            child: child,
          ),
        if (isScreenHidden)
          loading
              ? Container(
                  color: const Color(0xffFFFFFF),
                )
              : child,
        if (isEnabled)
          if (loading) _buildProgressIndicator(context),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.05,
      ),
      margin: EdgeInsets.only(
        top: marginTop ?? 0,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.green.shade400,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.025,
        ),
      ),
      child: SpinKitFoldingCube(
        color: loadingColor ?? Colors.blue,
        size: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }
}

class LoadingWidgetVisibility extends StatelessWidget {
  final bool loading;
  final Widget child;
  final Color loadingColor;
  final Color backgroundColor;
  const LoadingWidgetVisibility({
    Key? key,
    this.loading = false,
    required this.child,
    this.loadingColor = const Color(0xff45BFA9),
    this.backgroundColor = const Color(0x99000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Align(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              child: CircularProgressIndicator(
                color: loadingColor,
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
              ),
            ),
          )
        : child;
  }
}

class LazyLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isHorizontal;
  final Color loadingColor;
  const LazyLoading({
    Key? key,
    required this.child,
    this.isLoading = false,
    this.loadingColor = const Color(0xff45BFA9),
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Row(
        children: [
          child,
          if (isLoading) _provideLoading(context),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          child,
          if (isLoading) _provideLoading(context),
        ],
      );
    }
  }

  Widget _provideLoading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.06,
      ),
      child: CircularProgressIndicator(
        color: loadingColor,
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
      ),
    );
  }
}
