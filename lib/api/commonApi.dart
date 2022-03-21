import 'dart:convert';
import 'dart:io';
import 'package:flutter_tiktok/model/commonModel.dart';

import 'package:http/http.dart';

import '../global.dart';

class Api {
  static const String Server = "172.17.105.203:8080";
  static const String registerUrl = "/user/regist";
  static const String loginUrl = "/user/login";
  static const String updateVideoUrl = "/video/updateVideo";
  static const String requestVideosUrl = "/video/requestVideos";
  static const String requestUserPowerUrl = "/user/requestUserPower";
  static const String updateUserLoveUrl = "/user/updateUserLove";
  static const String deleteVideoUrl = "/video/deleteVideo";

  static Future<ResponseResult> registerUser(
      {required String name, required String pass}) async {
    Map params = {
      "name": name,
      "pass": pass,
    };
    return getUrl(params, registerUrl);
  }

  static Future<ResponseResult> loginUser(
      {required String name, required String pass}) async {
    Map params = {
      "name": name,
      "pass": pass,
    };
    return getUrl(params, loginUrl);
  }

  static Future<ResponseResult> updateVideo(
      {required String userName,
      required String videoUrl,
      String brand = "--",
      String type = "--",
      String price = "--",
      String age = "--"}) async {
    Map params = {
      "userName": userName,
      "videoUrl": videoUrl,
      "brand": brand,
      "type": type,
      "price": price,
      "age": carAgeMap[age == "--" ? noLimit : age] == 0
          ? 100
          : carAgeMap[age == "--" ? noLimit : age],
    };
    return getUrl(params, updateVideoUrl);
  }

  static Future<ResponseResult> deleteVideo({
    required String videoUrl,
  }) async {
    Map params = {
      "videoUrl": videoUrl,
    };
    return getUrl(params, deleteVideoUrl);
  }

  static Future<VideoList> requestVideos(
      {String? userName,
      String? brand,
      String? type,
      String? price,
      String? age}) async {
    brand = brand == defalutTypeList[1] ? noLimit : brand;
    type = type == defalutTypeList[2] ? noLimit : type;
    price = price == defalutTypeList[3] ? noLimit : price;
    age = age == defalutTypeList[4] ? noLimit : age;
    Map params = {
      "userName": userName ?? "",
      "selectBrand": brand ?? "--",
      "selectType": type ?? "--",
      "selectPrice": price == null ? 0 : carPriceMap[price],
      "selectAge": age == null ? 0 : carAgeMap[age],
    };
    ResponseResult result = await getUrl(params, requestVideosUrl);
    return VideoList.fromJson(result.data);
  }

  static Future<UserInfo> requestUserPower({String? userName}) async {
    Map params = {
      "userName": userName ?? "",
    };
    ResponseResult result = await getUrl(params, requestUserPowerUrl);
    print(result.data);
    return UserInfo.fromJson(result.data);
  }

  static Future<ResponseResult?> updateUserLove(
      {required UserVideo userVideo}) async {
    Map params = {
      "userName": userVideo.userName,
      "brand": userVideo.brand ?? "--",
      "type": userVideo.type ?? "--",
      "price": userVideo.price ?? 0,
      "age": (userVideo.age ?? 0) == 0 ? 100 : userVideo.age,
    };
    ResponseResult result = await getUrl(params, updateUserLoveUrl);
    print(result);
    return result;
  }

  static Future<List<UserVideo>> fetchVideo(
      {String? userName,
      String? brand,
      String? type,
      String? price,
      String? age}) async {
    videoList.clear();
    currentIndex = 0;
    VideoList listResult = await Api.requestVideos(
        userName: userName, brand: brand, type: type, price: price, age: age);
    List<UserVideo> list = listResult.videosList ?? [];
    for (int i = 0; i < list.length; i++) {
      videoList.add(list[i]);
    }
    return videoList;
  }

  static Future<ResponseResult> getUrl(
      Map<dynamic, dynamic>? params, String url) async {
    String stringUrl = "http://${Server}${url}" + getParam(params);
    print("url=${stringUrl}");
    var uri = Uri.parse(stringUrl);
    Response response = await get(uri);
    if (response.statusCode == HttpStatus.ok) {
      return ResponseResult.fromJson(jsonDecode(response.body));
    }
    {
      return ResponseResult(status: 100, message: "连接服务器失败", data: {});
    }
  }

  static String getParam(Map? param) {
    if (param == null || param.isEmpty) {
      return "";
    }
    String stringParam = "?";
    int cnt = 0;
    param.forEach((key, value) {
      cnt++;
      if (cnt != 1) {
        stringParam += "&";
      }
      stringParam += "${key}=${value}";
    });
    stringParam += "#";
    return stringParam;
  }
}
