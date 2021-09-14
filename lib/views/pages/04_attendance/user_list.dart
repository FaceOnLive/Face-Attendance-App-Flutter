import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';

class AttendedUserList extends StatefulWidget {
  const AttendedUserList({
    Key? key,
  }) : super(key: key);

  @override
  _AttendedUserListState createState() => _AttendedUserListState();
}

class _AttendedUserListState extends State<AttendedUserList> {
  // Mockup
  RxBool _fetchingData = true.obs;
  void _fetchAttendance() async {
    await Future.delayed(Duration(seconds: 3))
        .then((value) => {_fetchingData.value = false});
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  @override
  void dispose() {
    _fetchingData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text('Attended'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text('Unattended'),
                      ],
                    ),
                  ],
                ),
                // Filtering
                Row(
                  children: [
                    Text(
                      'Today',
                      style: AppText.caption,
                    ),
                    Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                    )
                  ],
                ),
              ],
            ),
            AppSizes.hGap10,

            Obx(
              () => _fetchingData.isTrue
                  ? _LoadingData()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: AppImages.unsplashPersons.length,
                        itemBuilder: (context, index) {
                          // if (index == AppImages.unsplashPersons.length) {
                          //   return Row(
                          //     children: [
                          //       Icon(
                          //         Icons.check_box_outline_blank_rounded,
                          //         color: Colors.red,
                          //       ),
                          //       AppSizes.wGap5,
                          //       Text('Unattended'),
                          //     ],
                          //   );
                          // }
                          // // UnAttended Person
                          // if (index > AppImages.unsplashPersons.length) {
                          //   return ListTile(
                          //     leading: CircleAvatar(
                          //       backgroundImage: CachedNetworkImageProvider(
                          //         AppImages.unsplashPersons[index],
                          //       ),
                          //     ),
                          //     title: Text('Name'),
                          //     subtitle: Text('+852 XXXX XXXX'),
                          //     trailing: Icon(Icons.pending_actions_rounded),
                          //   );
                          // }

                          // Attended Person
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                AppImages.unsplashPersons[index],
                              ),
                            ),
                            title: Text('Name'),
                            subtitle: Text('+852 XXXX XXXX'),
                            trailing: Icon(
                              Icons.check,
                              color: AppColors.APP_GREEN,
                            ),
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

// To Add A Loading List Effect
class _LoadingData extends StatelessWidget {
  const _LoadingData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: ListTile(
              leading: CircleAvatar(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppDefaults.defaulBorderRadius,
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
                      borderRadius: AppDefaults.defaulBorderRadius,
                    ),
                    child: Text('+852 XXXX XXXXgegege g'),
                  ),
                ],
              ),
              trailing: Container(
                child: Icon(Icons.info_rounded),
              ),
            ),
          );
        },
      ),
    );
  }
}
