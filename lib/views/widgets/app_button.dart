import 'package:face_attendance/consts/app_colors.dart';
import 'package:face_attendance/consts/app_defaults.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.width,
    this.margin,
    this.padding,
    this.color = AppColors.PRIMARY_COLOR,
  }) : super(key: key);

  final String label;
  final void Function() onTap;
  final bool isLoading;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDefaults.defaultDuration,
        margin: margin ?? EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppDefaults.defaulBorderRadius,
        ),
        width: width,
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                label,
                style: AppText.b1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
