import 'package:flutter/material.dart';
import 'package:flutter_tiktok/api/commonApi.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/model/commonModel.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';
import 'package:flutter_tiktok/widgets/popupWidget.dart';
import 'package:get/get.dart';

class CarDetailWidget extends StatefulWidget {
  final UserVideo userVideo;
  final void Function() deleteCallBack;

  const CarDetailWidget(
      {required this.userVideo,
      required this.width,
      required this.deleteCallBack});

  final width;

  @override
  State<CarDetailWidget> createState() => _CarDetailWidgetState();
}

class _CarDetailWidgetState extends State<CarDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController widthController;
  double width = 0;
  RxBool isLoadingObs = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widthController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: kAnimationDuration),
        lowerBound: 0,
        upperBound: widget.width);
    widthController.addListener(() {
      if (widthController.value <= 0.01) {
        widthController.stop();
        Navigator.pop(context);
      } else if (mounted) {
        setState(() {
          width = widthController.value;
        });
      }
    });
    widthController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          popPage(context);
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: width,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.orange,
                      height: height / 5,
                      child: Text(
                        "具体信息",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(left: 28),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              _buildTypeDetailWidget(
                                  type: defalutTypeList[1],
                                  detail: widget.userVideo.brand),
                              _buildTypeDetailWidget(
                                  type: defalutTypeList[2],
                                  detail: widget.userVideo.type),
                              _buildTypeDetailWidget(
                                  type: defalutTypeList[4],
                                  detail: (widget.userVideo.age ?? 0) == 0
                                      ? "--"
                                      : carAge[widget.userVideo.age!]),
                              _buildTypeDetailWidget(
                                  type: defalutTypeList[3],
                                  detail:
                                      ("${widget.userVideo.price ?? "--"}") +
                                          "万元",
                                  color: Colors.red),
                              SizedBox(height: 26),
                              _buildDeleteButton(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDetailWidget(
      {required String type,
      String? detail = "--",
      Color color = Colors.black}) {
    return Padding(
      padding: EdgeInsets.only(right: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            type + " :",
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 6),
          Center(
            child: Text(
              detail ?? "--",
              style: TextStyle(color: color, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        hindleHindle();
      },
      child: Obx(() => isLoadingObs.value == true
          ? Center(
              child: Padding(
                padding: EdgeInsets.only(right: 34),
                child: LoadingCircular(
                  color: Colors.blue,
                ),
              ),
            )
          : Text(
              "删除此视频",
              style: TextStyle(color: Colors.red),
            )),
    );
  }

  Future<void> hindleHindle() async {
    isLoadingObs.value = true;
    UserInfo userInfo = await Api.requestUserPower(userName: currentUserName);
    print("userInfo=power=${userInfo.power},name=${userInfo.name}");
    isLoadingObs.value = false;

    RxBool isDeleteing = false.obs;
    if (currentUserName == widget.userVideo.userName ||
        (userInfo.power ?? 1) >= UserPower.administrator) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupWidget(
              text: "您确定要删除此视频吗",
              existConfirm: true,
              confirmWidget: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if(isDeleteing.value==true){
                    return ;
                  }
                  isDeleteing.value = true;
                  ResponseResult result = await Api.deleteVideo(
                      videoUrl: widget.userVideo.videoUrl ?? "");
                  isDeleteing.value = false;
                  if (result.isSuccess) {
                    widget.deleteCallBack();
                    FlutterToast.show("删除成功");
                  } else {
                    FlutterToast.show(result.message ?? "删除失败");
                  }
                },
                child: Center(
                    child: Obx(
                  () => isDeleteing.value == true
                      ? LoadingCircular(
                          color: Colors.deepOrange,
                        )
                      : Text(
                          "确定",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                )),
              ),
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupWidget(
            text: "抱歉，您没有权限执行该操作，请联系开发者获取管理员权限",
            cancelTitle: "知道了",
          );
        },
      );
    }
  }

  void popPage(BuildContext context) {
    if (widthController.isAnimating) {
      return;
    }
    widthController.reverse();
  }

  @override
  void dispose() {
    widthController.dispose();
    super.dispose();
  }
}
