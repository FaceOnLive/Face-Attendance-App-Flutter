import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/models/log_message.dart';
import '../../../../core/themes/text.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';

class SpaceLogScreen extends StatefulWidget {
  const SpaceLogScreen({Key? key}) : super(key: key);

  @override
  _SpaceLogScreenState createState() => _SpaceLogScreenState();
}

class _SpaceLogScreenState extends State<SpaceLogScreen> {
  /* <---- Dependency -----> */
  final SpaceController _controller = Get.find();

  // Progress
  final RxBool _isFetching = false.obs;

  // Fetch Data
  Future<void> _fetchAllLog() async {
    if (_controller.currentSpace != null) {
      _isFetching.trigger(true);
      try {
        _allLogSpace = await _controller.fetchLogMessages(
          spaceID: _controller.currentSpace!.spaceID!,
        );
        _isFetching.trigger(false);
      } on Exception catch (e) {
        _isFetching.trigger(false);
        AppToast.show(e.toString());
      }
    }
  }

  List<LogMessage> _allLogSpace = [];

  @override
  void initState() {
    super.initState();
    _fetchAllLog();
  }

  @override
  void dispose() {
    _isFetching.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
        actions: [
          Obx(
            () => _isFetching.isTrue
                ? const SizedBox()
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_forever_rounded),
                  ),
          ),
        ],
      ),
      body: Container(
        width: Get.width,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDefaults.margin,
        ),
        child: Obx(
          () => _isFetching.isTrue
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: _allLogSpace.isNotEmpty
                          ? ListView.separated(
                              itemCount: _allLogSpace.length,
                              itemBuilder: (context, index) {
                                return _LogMessageTile(
                                  message: _allLogSpace[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.illustrationSpaceEmpty,
                                  width: Get.width * 0.6,
                                ),
                                AppSizes.hGap20,
                                const Text('Nothing is logged today')
                              ],
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LogMessageTile extends StatelessWidget {
  const _LogMessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final LogMessage message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: message.thumbnail != null
          ? CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(message.thumbnail!),
            )
          : null,
      title: Text(message.message),
      subtitle: Text(
        DateFormat.yMMMEd().format(DateTime.now()),
        style: AppText.caption,
      ),
      trailing: message.isAnError
          ? const Icon(
              Icons.close,
              color: AppColors.appRed,
            )
          : const Icon(
              Icons.check,
              color: Colors.green,
            ),
    );
  }
}
