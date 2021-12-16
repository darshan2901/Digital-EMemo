import 'package:flutter/material.dart';

class HideOverGlow extends StatelessWidget {
  Widget? child;
  HideOverGlow({this.child});
  @override
  Widget build(BuildContext context) {
    return  NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              } as bool Function(OverscrollIndicatorNotification)?,
              child: child!,);
  }
}
