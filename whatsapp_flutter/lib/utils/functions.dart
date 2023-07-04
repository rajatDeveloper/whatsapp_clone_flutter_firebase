import 'package:flutter/material.dart';

double getDeviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getDeviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

double getFontSize(double size, double screenWidth) {
  return size * screenWidth / 414;
}
