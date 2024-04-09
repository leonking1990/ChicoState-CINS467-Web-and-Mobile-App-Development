import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color outlineColor;
  final double outlineThickness;

  const OutlinedText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.outlineColor = Colors.black,
    this.outlineThickness = 2.0, required RichText child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Paints the outline by duplicating the text and offsetting it slightly
    return Stack(
      children: <Widget>[
        // Outline
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineThickness
              ..color = outlineColor,
          ),
        ),
        // Foreground text
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}

class MultiColorOutlinedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color firstHalfColor;
  final Color secondHalfColor;
  final Color outlineColor;

  const MultiColorOutlinedText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.firstHalfColor = Colors.white,
    this.secondHalfColor = Colors.red,
    this.outlineColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final halfLength = text.length ~/ 2; // Calculate the halfway point of the text

    return OutlinedText(
      text: text,
      textStyle: textStyle,
      outlineColor: outlineColor,
      outlineThickness: 2.0, // Adjust the thickness of the outline here
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: text.substring(0, halfLength),
              style: textStyle.copyWith(color: firstHalfColor),
            ),
            TextSpan(
              text: text.substring(halfLength),
              style: textStyle.copyWith(color: secondHalfColor),
            ),
          ],
        ),
      ),
    );
  }
}



