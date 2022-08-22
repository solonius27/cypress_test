import 'package:cypress_test/sizeConfig.dart';
import 'package:flutter/material.dart';

Widget appText(String tx, double size,
    {FontWeight weight = FontWeight.w400,
    topmargin = 0.0,
    bottommargin = 0.0,
    leftmargin = 0.0,
    rightmargin = 0.0,
    TextAlign align = TextAlign.center,
    Color color = Colors.black,
    double? space,
    bool softwrap = true,
    TextOverflow? overflow,
    TextDecoration? decoration,
    int? maxlines,
    FontStyle fontStyle = FontStyle.normal}) {
  return Container(
    margin: EdgeInsets.only(
        top: calculateSize(topmargin),
        bottom: calculateSize(bottommargin),
        left: calculateSize(leftmargin),
        right: calculateSize(rightmargin)),
    child: Text(
      tx == null ? "" : tx,
      softWrap: softwrap,
      overflow: overflow,
      maxLines: maxlines,
      textAlign: align,
      style: TextStyle(
        decoration: decoration,
        fontSize: calculateSize(size),
        fontWeight: weight,
        fontStyle: fontStyle,
        color: color,
        letterSpacing: space,
      ),
    ),
  );
}

double calculateSize(double size) {
  var val = size / 8.53;
  return val * SizeConfig.heightMultiplier!;
}

final pageMargin = EdgeInsets.only(
  left: calculateSize(28),
  right: calculateSize(28),
  top: calculateSize(20),
);
