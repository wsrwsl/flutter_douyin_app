import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/widgets/tikTokVideoGesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///
class TikTokVideoPage extends StatefulWidget {
  final Widget? video;
  final double aspectRatio;
  final String? tag;
  final double bottomPadding;
  final Widget? leftBottomDetail;
  final Widget? userInfoWidget;

  final bool hidePauseIcon;

  final Function? onAddFavorite;
  final Function? onSingleTap;

  const TikTokVideoPage({
    Key? key,
    this.bottomPadding: 16,
    this.tag,
    this.userInfoWidget,
    this.onAddFavorite,
    this.onSingleTap,
    this.video,
    this.aspectRatio: 9 / 16.0,
    this.hidePauseIcon: false,
    this.leftBottomDetail,
  }) : super(key: key);

  @override
  State<TikTokVideoPage> createState() => _TikTokVideoPageState();
}

class _TikTokVideoPageState extends State<TikTokVideoPage> {



  @override
  Widget build(BuildContext context) {
    // 视频加载的动画
    // Widget videoLoading = VideoLoadingPlaceHolder(tag: tag);
    // 视频播放页
    Widget videoContainer = Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: Container(
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: widget.video,
            ),
          ),
        ),
        widget.hidePauseIcon
            ? Container()
            : Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 120,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
        TikTokVideoGesture(
          onAddFavorite: widget.onAddFavorite,
          onSingleTap: widget.onSingleTap,
          child: Container(
            color: ColorPlate.clear,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ],
    );
    Widget body = Container(
      child: Stack(
        children: <Widget>[
          videoContainer,
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child: widget.leftBottomDetail??Container(),
          )

        ],
      ),
    );
    return body;
  }

}

class VideoLoadingPlaceHolder extends StatelessWidget {
  const VideoLoadingPlaceHolder({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            size: 36,
            color: Colors.white.withOpacity(0.3),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: Text(
              tag,
              style: StandardTextStyle.normalWithOpacity,
            ),
          ),
        ],
      ),
    );
  }
}
