import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  final double? width;
  final Color? textColor;
  final Color? btnColor;
  const CustomButton(
      {super.key,
      required this.text,
      required this.voidCallback,
      this.width,
      this.textColor,
      this.btnColor});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: InkWell(
        onTap: voidCallback,
        child: Container(
          width: width ?? double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: btnColor ?? Colors.amber),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
        ),
      ),
    );
  }
}
