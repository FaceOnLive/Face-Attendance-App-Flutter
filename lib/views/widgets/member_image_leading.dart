import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_images.dart';
import 'package:flutter/material.dart';

/// A widget that holds an user image in a c circle avatar
class MemberImageLeading extends StatelessWidget {
  const MemberImageLeading({
    Key? key,
    required this.imageLink,
    this.radius,
  }) : super(key: key);

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
