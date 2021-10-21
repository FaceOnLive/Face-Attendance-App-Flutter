import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import 'package:flutter/material.dart';

class SpaceLogScreen extends StatefulWidget {
  const SpaceLogScreen({Key? key}) : super(key: key);

  @override
  _SpaceLogScreenState createState() => _SpaceLogScreenState();
}

class _SpaceLogScreenState extends State<SpaceLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSizes.DEFAULT_MARGIN,
        ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(),
              title: Text('Huang Attended on 1.00 PM '),
              subtitle: Text('22 September 2021'),
              trailing: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: CircleAvatar(),
              title: Text('Lisa, Ting and 3 others Are unattended today'),
              subtitle: Text('22 September 2021'),
              trailing: Icon(
                Icons.info_rounded,
                color: AppColors.APP_RED,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
