// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commonModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseResult _$ResponseResultFromJson(Map<String, dynamic> json) =>
    ResponseResult(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ResponseResultToJson(ResponseResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

VideoList _$VideoListFromJson(Map<String, dynamic> json) => VideoList(
      videosList: (json['videosList'] as List<dynamic>?)
          ?.map((e) => UserVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoListToJson(VideoList instance) => <String, dynamic>{
      'videosList': instance.videosList,
    };

UserVideo _$UserVideoFromJson(Map<String, dynamic> json) => UserVideo(
      videoUrl: json['videoUrl'] as String?,
      desc: json['desc'] as String?,
      userName: json['userName'] as String?,
      brand: json['brand'] as String?,
      type: json['type'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      age: json['age'] as int?,
    );

Map<String, dynamic> _$UserVideoToJson(UserVideo instance) => <String, dynamic>{
      'videoUrl': instance.videoUrl,
      'desc': instance.desc,
      'userName': instance.userName,
      'brand': instance.brand,
      'type': instance.type,
      'price': instance.price,
      'age': instance.age,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      name: json['name'] as String?,
      power: json['power'] as int?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'power': instance.power,
    };
