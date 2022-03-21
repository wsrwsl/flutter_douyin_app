//dart 2.9
import 'dart:io';
import 'package:flutter_tiktok/api/commonApi.dart';
import 'package:flutter_tiktok/api/updateVideoToOssApi.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/model/commonModel.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapped/tapped.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  static const String hintContext = "请选择";
  RxInt selectTypeObs = SelectType.defalut.obs;
  var uploadSooState = UpdateState.notUpdate.obs;
  var uploadServeState = UpdateState.notUpdate.obs;
  TextEditingController controllerBrand = TextEditingController();
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  RxString brandObs = hintContext.obs;
  RxString typeObs = hintContext.obs;
  RxString ageObs = hintContext.obs;
  String currentVideoUrl = "";
  RxBool showTipsObs = false.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var closeButton = Tapped(
      child: Container(
        width: 40,
        height: 40,
        child: Icon(Icons.clear, color: Colors.black),
      ),
      onTap: () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            child: closeButton,
            left: 10,
            top: 10,
          ),
          Column(
            children: [
              SizedBox(height: 70),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildUploadWidget(),
                    _buildHindleSelectWidget(
                        stringObs: brandObs,
                        selectType: SelectType.brand,
                        onTap: () async {
                          List<String> temp = List.from(carBrand);
                          temp[0] = "--";
                          String? result = await HindleSelectSheet.hindleSelect(
                            context: context,
                            selectType: SelectType.brand,
                            controller: controllerBrand,
                            list: temp,
                          );
                          brandObs.value = result ?? brandObs.value;
                        }),
                    _buildHindleSelectWidget(
                        stringObs: typeObs,
                        selectType: SelectType.type,
                        onTap: () async {
                          List<String> temp = List.from(carType);
                          temp[0] = "--";
                          String? result = await HindleSelectSheet.hindleSelect(
                            context: context,
                            selectType: SelectType.type,
                            controller: controllerType,
                            list: temp,
                          );
                          typeObs.value = result ?? typeObs.value;
                        }),
                    _buildPriceWidget(),
                    _buildHindleSelectWidget(
                        stringObs: ageObs,
                        selectType: SelectType.age,
                        onTap: () async {
                          List<String> temp = List.from(carAge);
                          temp[0] = "--";
                          String? result = await HindleSelectSheet.hindleSelect(
                            context: context,
                            selectType: SelectType.age,
                            list: temp,
                          );
                          ageObs.value = result ?? ageObs.value;
                        }),
                    SizedBox(height: 14),
                    _buildUploadButton(),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
  Widget _buildPriceWidget(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 14),
        Row(
          children: [
            Text(defalutTypeList[3],
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Text(" : ", style: TextStyle(color: Colors.black, fontSize: 16)),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                  hintText: "请输入价格",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.black54)),
                ),
                controller: controllerPrice,
              ),
            ),
            Text("万元",style:TextStyle(
                color: Colors.red,
                fontSize: 16),),
          ],
        ),
      ],
    );
  }
  Widget _buildUploadWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Row(children: [
          Text("上传视频", style: TextStyle(color: Colors.black, fontSize: 16)),
          Text(" *", style: TextStyle(color: Colors.red, fontSize: 16)),
          Text(" : ", style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (uploadSooState.value == UpdateState.updateing) {
                return;
              }
              uploadVideoToOss();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFFEEEEEE)),
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Obx(() {
                if (uploadSooState.value == UpdateState.sucess) {
                  return Text("上传成功", style: TextStyle(color: Colors.grey));
                } else if (uploadSooState.value == UpdateState.updateing) {
                  return LoadingCircular(color: Colors.grey, size: 18);
                } else {
                  return Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 64,
                  );
                }
              }),
            ),
          ),
          Obx(
            () => showTipsObs.value == true
                ? Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("(未上传视频)",
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  )
                : Container(),
          ),
        ]),
      ],
    );
  }

  Widget _buildHindleSelectWidget(
      {required RxString stringObs,
      required GestureTapCallback onTap,
      required int selectType}) {
    return Obx(() => stringObs.value == hintContext
        ? SelectTerm(
            left: defalutTypeList[selectType],
            right: stringObs.value,
            isHint: true,
            onTap: onTap,
          )
        : SelectTerm(
            left: defalutTypeList[selectType],
            right: stringObs.value,
            onTap: onTap,
          ));
  }

  Widget _buildUploadButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (uploadServeState.value == UpdateState.updateing) {
            return;
          }
          uploadVideoToServe();
        },
        child: RadiusContainer(
          width: 100,
          radius: 20,
          child: Obx(() => uploadServeState.value == UpdateState.updateing
              ? LoadingCircular()
              : Text("上传")),
        ),
      ),
    );
  }

  Future<File?> _getVideo() async {
    var pick = ImagePicker();
    XFile? video = await pick.pickVideo(source: ImageSource.gallery);
    File? file;
    if (video != null) {
      file = File(video.path);
    }
    return file;
  }

  Future<void> uploadVideoToOss() async {
    File? file = await _getVideo();
    if (file == null) {
      return;
    }
    uploadSooState.value = UpdateState.updateing;
    currentVideoUrl = await UploadOss.upload(file: file);
    showTipsObs.value = false;
    uploadSooState.value = UpdateState.sucess;
    print("url=@{currentVideoUrl}");
  }

  void uploadVideoToServe() async {
    if (currentVideoUrl == "") {
      showTipsObs.value = true;
      return;
    }
    uploadServeState.value = UpdateState.updateing;
    ResponseResult result = await Api.updateVideo(
      userName: currentUserName,
      videoUrl: currentVideoUrl,
      brand: brandObs.value == hintContext ? "--" : brandObs.value,
      type: typeObs.value == hintContext ? "--" : typeObs.value,
      price: controllerPrice.text==""? "--" : controllerPrice.text,
      age: ageObs.value == hintContext ? "--" : ageObs.value,
    );

    if (result.isSuccess == true) {
      uploadServeState.value = UpdateState.sucess;
      currentVideoUrl = "";
      uploadSooState.value = UpdateState.notUpdate;
      FlutterToast.show("上传成功");
    } else {
      FlutterToast.show(result.message ?? "上传失败");
      uploadServeState.value = UpdateState.fail;
    }
  }
}
