import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

/// A widget that holds an user image in a c circle avatar
class MemberImageLeading extends StatelessWidget {
  const MemberImageLeading({
    super.key,
    required this.imageLink,
    this.radius,
  });

  final String? imageLink;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (imageLink != null) {
      return CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageLink!),
        radius: radius,
      );
    } else {
      return CircleAvatar(
        backgroundImage: const AssetImage(AppImages.deafaultUser),
        radius: radius,
      );
    }
  }
}
