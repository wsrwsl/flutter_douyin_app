import 'package:flutter_tiktok/api/commonApi.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/model/commonModel.dart';
import 'package:flutter_tiktok/pages/cameraPage.dart';
import 'package:flutter_tiktok/pages/userPage.dart';
import 'package:flutter_tiktok/style/physics.dart';
import 'package:flutter_tiktok/widgets/PageRouteBuilderWidget.dart';
import 'package:flutter_tiktok/widgets/carDetailWidget.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';
import 'package:flutter_tiktok/widgets/tikTokHeader.dart';
import 'package:flutter_tiktok/widgets/tikTokScaffold.dart';
import 'package:flutter_tiktok/widgets/tikTokVideo.dart';
import 'package:flutter_tiktok/controller/tikTokVideoListController.dart';
import 'package:flutter_tiktok/widgets/tiktokTabBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  PageController _pageController = PageController();

  TikTokVideoListController _videoListController = TikTokVideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  late DateTime preTime;
  late DateTime currentTime;
  int preIndex = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  void hindleRefreshVideo() {
    WidgetsBinding.instance!.addObserver(this);
    _videoListController.init(
      pageController: _pageController,
      initialList: videoDataList
          .map(
            (e) => VPVideoController(
              videoInfo: e,
              builder: () => VideoPlayerController.network(e.videoUrl ?? ""),
            ),
          )
          .toList(),
      videoProvider: (int index, List<VPVideoController> list) async {
        return videoDataList
            .map(
              (e) => VPVideoController(
                videoInfo: e,
                builder: () => VideoPlayerController.network(e.videoUrl ?? ""),
              ),
            )
            .toList();
      },
    );
    _videoListController.addListener(() {
      setState(() {});
    });
    tkController.addListener(
      () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );
    preTime = DateTime.now();
  }

  void init() async {
    videoDataList = await Api.fetchVideo();
    hindleRefreshVideo();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? currentPage;

    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.me:
        currentPage = UserPage(isSelfPage: true);
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.home;
    if (hasBottomPadding) {
      hasBackground = true;
    }
    Widget tikTokTabBar = TikTokTabBar(
      hasBackground: hasBackground,
      current: tabBarType,
      onTabSwitch: (type) async {
        setState(() {
          tabBarType = type;
          if (type == TikTokPageTag.home) {
            _videoListController.currentPlayer.play();
          } else {
            _videoListController.currentPlayer.pause();
          }
        });
      },
      onAddButton: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CameraPage(),
          ),
        );
      },
    );

    var userPage = UserPage(
      isSelfPage: false,
      canPop: true,
      onPop: () {
        tkController.animateToMiddle();
      },
    );

    var header = tabBarType == TikTokPageTag.home
        ? TikTokHeader(
            setState: () {
              setState(() {
                hindleRefreshVideo();
              });
            },
          )
        : Container();

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: tikTokTabBar,
      header: header,
      rightPage: userPage,
      enableGesture: tabBarType == TikTokPageTag.home,
      onPullDownRefresh: () {
        setState(() {
          init();
        });
      },
      leftDown: () {
        print("current=${currentIndex},len=${videoDataList.length}");
        if(videoList.isEmpty||videoDataList.isEmpty){
          return ;
        }
        hindleShowDialog(context, videoDataList[currentIndex]);
      },
      page: Obx(
        () => videoList.isEmpty
            ? Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingCircular(size: 20),
                  SizedBox(height: 6),
                  Text(
                    "暂无视频",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ))
            : Stack(
                // index: currentPage == null ? 0 : 1,
                children: <Widget>[
                  PageView.builder(
                    key: Key('home+${DateTime.now().toString()}'),
                    physics: QuickerScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _videoListController.videoCount,
                    onPageChanged: (index) async {
                      print("index=${index}");
                      preIndex = currentIndex;
                      currentIndex = index;
                      currentTime = DateTime.now();
                      await hindleIsLove();
                      preTime = currentTime;
                    },
                    itemBuilder: (context, i) {
                      // 拼一个视频组件出来
                      //bool isF = SafeMap(favoriteMap)[i].boolean ?? false;
                      var player = _videoListController.playerOfIndex(i)!;
                      var data = player.videoInfo!;
                      // video
                      Widget currentVideo = Center(
                        child: AspectRatio(
                          aspectRatio: player.controller.value.aspectRatio,
                          child: VideoPlayer(player.controller),
                        ),
                      );

                      currentVideo = TikTokVideoPage(
                        // 手势播放与自然播放都会产生暂停按钮状态变化，待处理
                        hidePauseIcon: !player.showPauseIcon.value,
                        aspectRatio: 9 / 16.0,
                        key: Key(data.videoUrl ?? "" + '$i'),
                        tag: data.videoUrl ?? "",
                        bottomPadding: hasBottomPadding ? 16.0 : 16.0,
                        leftBottomDetail: Container(),
                        onSingleTap: () async {
                          print("onSingle");
                          if (player.controller.value.isPlaying) {
                            print("isPlay");
                            await player.pause();
                          } else {
                            print("isNotPlay");
                            await player.play();
                          }
                          setState(() {});
                        },
                        onAddFavorite: () {
                          setState(() {
                            favoriteMap[i] = true;
                          });
                        },
                        video: currentVideo,
                      );
                      return currentVideo;
                    },
                  ),
                  currentPage ?? Container(),
                ],
              ),
      ),
    );
  }

  void hindleShowDialog(BuildContext context, UserVideo userVideo) {
    double width = MediaQuery.of(context).size.width / 2;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CarDetailWidget(
            userVideo: userVideo,
            width: width,
            deleteCallBack: init,
          );
        });
  }

  Future<void> hindleIsLove() async {
    var player = _videoListController.playerOfIndex(preIndex)!;
    var time = await player.controller.position;
    print(preTime);
    print(currentTime);
    int differSeconds = currentTime.difference(preTime).inSeconds;
    print("differ=${differSeconds}");
    if (differSeconds >= 2) {
      Api.updateUserLove(userVideo: videoList[preIndex]);
    }
  }
}
