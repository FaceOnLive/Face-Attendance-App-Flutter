import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import 'member_info.dart';
import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MembersList extends StatefulWidget {
  const MembersList({
    Key? key,
  }) : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
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
        child: Obx(
          () => _fetchingData.isTrue
              ? _LoadingData()
              : ListView.builder(
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
                      onTap: () {
                        Get.to(() => MemberInfoScreen());
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          AppImages.unsplashPersons[index],
                        ),
                      ),
                      title: Text('Members Name'),
                      subtitle: Text('+852 XXXX XXXX'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.info_outlined,
                          color: AppColors.APP_GREEN,
                        ),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
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
    return ListView.builder(
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
    );
  }
}
