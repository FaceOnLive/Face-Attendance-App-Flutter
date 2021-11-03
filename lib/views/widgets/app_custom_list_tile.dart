import 'package:face_attendance/constants/constants.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class AppCustomListTile extends StatelessWidget {
  const AppCustomListTile({
    Key? key,
    required this.onTap,
    this.label,
    this.leading,
    this.trailing,
    this.isUpdating = false,
    this.updateMessage,
    this.subtitle,
  }) : super(key: key);

  final void Function() onTap;
  final String? label;
  final Icon? leading;
  final Widget? trailing;
  final bool isUpdating;
  final String? updateMessage;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
        borderRadius: AppDefaults.defaulBorderRadius,
        splashColor: AppColors.shimmerHighlightColor,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: AppSizes.DEFAULT_MARGIN,
              vertical: AppSizes.DEFAULT_MARGIN / 2),
          decoration: BoxDecoration(
            boxShadow: AppDefaults.defaultBoxShadow,
            color: context.theme.cardColor,
            borderRadius: AppDefaults.defaulBorderRadius,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(AppSizes.DEFAULT_PADDING / 2),
            enabled: true,
            leading: leading ?? Icon(Icons.person_rounded),
            title: Text(
              label ?? 'Add Text Here',
              style: context.textTheme.bodyText1,
            ),
            subtitle: isUpdating
                ? Text(
                    updateMessage ?? 'Updating...',
                    style: AppText.caption,
                  )
                : subtitle == null
                    ? null
                    : Text(subtitle!, style: AppText.caption),
            trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
