import 'package:flutter/cupertino.dart';

class FadeAnimation extends StatefulWidget {
  Duration? duration;
  Widget? child;
  FadeAnimation({this.duration,this.child});
  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation fadeanimation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: widget.duration);
    // ..repeat(reverse: true);
    fadeanimation =
        Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward().whenComplete(() {
      // controller.reverse();
    });
    // Future.delayed(Duration(seconds: 2)).then((value) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => Onboarding()),
    //       (route) => false);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  } @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
                      animation: fadeanimation,
                      builder: (context, newwidget) {
        return Opacity(

          opacity: fadeanimation.value,
          child: widget.child,
        );
      }
    );
  }
}
