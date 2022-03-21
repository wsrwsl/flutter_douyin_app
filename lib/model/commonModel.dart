
//flutter packages pub run build_runner build

import 'package:json_annotation/json_annotation.dart';
part 'commonModel.g.dart';



@JsonSerializable()
class ResponseResult{
  int? status;
  String? message;
  Map<String,dynamic>? data;
  bool get isSuccess{
    return status==0;
  }
  ResponseResult({this.status,this.message,this.data});
  factory ResponseResult.fromJson(Map<String, dynamic> json) => _$ResponseResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseResultToJson(this);
}

@JsonSerializable()
class VideoList{
  List<UserVideo>? videosList;
  VideoList({this.videosList});
  factory VideoList.fromJson(Map<String, dynamic>? json) => json==null?VideoList():_$VideoListFromJson(json);
  Map<String, dynamic> toJson() => _$VideoListToJson(this);
}



@JsonSerializable()
class UserVideo {
  String? videoUrl;
  String? desc;
  String? userName;
  String? brand;
  String? type;
  double? price;
  int? age;
  String? get image{
    return videoUrl;
  }
  UserVideo({
    required this.videoUrl,
    this.desc,
    this.userName,
    this.brand,
    this.type,this.price,
    this.age,
  });
  factory UserVideo.fromJson(Map<String, dynamic> json) => _$UserVideoFromJson(json);
  Map<String, dynamic> toJson() => _$UserVideoToJson(this);

  @override
  String toString() {
    return 'image:$image' '\nvideo:$videoUrl';
  }
}

@JsonSerializable()
class UserInfo {
  String? name;
  int? power;

  UserInfo({
    this.name,
    this.power,
  });
  factory UserInfo.fromJson(Map<String, dynamic>? json) => json==null?UserInfo():_$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}