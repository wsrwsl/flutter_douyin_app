import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/material.dart';

import 'backButton.dart';


class TikTokAppbar extends StatelessWidget {
  const TikTokAppbar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: ColorPlate.back2,
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            IosBackButton(),
            Expanded(
              child: Text(
                title ?? '未定标题',
                textAlign: TextAlign.center,
                style: StandardTextStyle.big,
              ),
            ),
            Opacity(
              opacity: 0,
              child: Icon(
                Icons.panorama_fish_eye,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
