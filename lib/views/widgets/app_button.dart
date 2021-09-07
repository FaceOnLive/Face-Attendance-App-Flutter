import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
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
    this.height,
    this.suffixIcon,
    this.prefixIcon,
    this.color,
  }) : super(key: key);

  final String label;
  final void Function() onTap;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Icon? suffixIcon;
  final Icon? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        height: height,
        duration: AppDefaults.defaultDuration,
        margin: margin ?? EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: color ?? AppColors.PRIMARY_COLOR,
          borderRadius: AppDefaults.defaulBorderRadius,
        ),
        width: width,
        child: isLoading
            ? AspectRatio(
                aspectRatio: 1 / 1,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefixIcon != null
                      ? Container(
                          margin: EdgeInsets.only(left: 5), child: prefixIcon)
                      : SizedBox(),
                  Text(
                    label,
                    style: AppText.b1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon != null
                      ? Container(
                          margin: EdgeInsets.only(left: 5), child: suffixIcon)
                      : SizedBox(),
                ],
              ),
      ),
    );
  }
}
