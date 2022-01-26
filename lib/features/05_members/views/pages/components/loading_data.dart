import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/themes/text.dart';

class LoadingMemberData extends StatelessWidget {
// To Add A Loading List Effect
  const LoadingMemberData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: ListTile(
            leading: const CircleAvatar(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: Text(
                    'Hello Testge g',
                    style: AppText.b1,
                  ),
                ),
                AppSizes.hGap5,
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: const Text('+852 XXXX XXXXgegege g'),
                ),
              ],
            ),
            trailing: const Icon(Icons.info_rounded),
          ),
        );
      },
    );
  }
}
