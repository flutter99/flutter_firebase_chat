import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isLoading;
  final String buttonText;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? borderColor;
  final Color? splashColor;
  final double? horizontalMargin;
  final double? fontSize;
  final double? btnHeight;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    required this.buttonText,
    this.buttonColor = Colors.green,
    this.buttonTextColor = Colors.white,
    this.borderColor = Colors.green,
    this.splashColor,
    this.horizontalMargin = 0.0,
    this.fontSize = 18,
    this.btnHeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin!),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          onPrimary: splashColor ?? Colors.white.withOpacity(0.2),
          onSurface: splashColor ?? Colors.white.withOpacity(0.2),
          maximumSize: Size.fromHeight(btnHeight ?? 50),
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
          side: BorderSide(
            color: borderColor!,
            width: 1.0,
          ),
        ),
        child: Center(
          child: isLoading == true
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  buttonText,
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
