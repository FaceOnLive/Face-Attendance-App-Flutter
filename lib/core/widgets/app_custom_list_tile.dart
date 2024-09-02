import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../../../../core/constants/constants.dart';
import '../../core/themes/text.dart';

class AppCustomListTile extends StatelessWidget {
  const AppCustomListTile({
    super.key,
    required this.onTap,
    this.label,
    this.leading,
    this.trailing,
    this.isUpdating = false,
    this.updateMessage,
    this.subtitle,
  });

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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        splashColor: AppColors.shimmerHighlightColor,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppDefaults.margin, vertical: AppDefaults.margin / 2),
          decoration: BoxDecoration(
            boxShadow: AppDefaults.boxShadow,
            color: context.theme.cardColor,
            borderRadius: AppDefaults.borderRadius,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppDefaults.padding / 2),
            enabled: true,
            leading: leading ?? const Icon(Icons.person_rounded),
            title: Text(
              label ?? 'Add Text Here',
              style: context.textTheme.bodySmall,
            ),
            subtitle: isUpdating
                ? Text(
                    updateMessage ?? 'Updating...',
                    style: AppText.caption,
                  )
                : subtitle == null
                    ? null
                    : Text(subtitle!, style: AppText.caption),
            trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
