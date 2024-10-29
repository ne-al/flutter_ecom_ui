import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingAnimation() {
  return Center(
    child: LoadingAnimationWidget.stretchedDots(
      color: Colors.white,
      size: 50,
    ),
  );
}
