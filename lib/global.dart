import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tiktok/model/commonModel.dart';
import 'package:get/get.dart';

String currentUserName="xxx";
Socket? socket;
RxList<UserVideo> videoList =<UserVideo> [].obs;
const int kAnimationDuration=300;
const Color backgroundColor=Color(0xFFEEEEEE);

int currentIndex=0;
//筛选选项
const String other = "其他";
const String noLimit = "不限";


enum UpdateState {
  notUpdate,
  updateing,
  sucess,
  fail,
}
class UserPower{
  static const int client=1;
  static const int administrator=2;
}


class SelectType{
  static const int defalut=0;
  static const int brand=1;
  static const int type=2;
  static const int price=3;
  static const int age=4;
}

const List<String> defalutTypeList =const ["", "品牌", "车型","价格", "年限"];

const List<String> carBrand =const [noLimit, '大众', '小众', '名牌', other];
const List<String> carType = const[noLimit, 'A', 'B', 'C', other];

const List<String> carPrice = const[
  noLimit,
  "5万以下",
  "5-10万",
  "10-15万",
  "15-25万",
  "25-50万",
  "50万以上"
];

const List<String> carAge = const[
  noLimit,
  "一年以内",
  "两年以内",
  "三年以内",
  "四年以内",
  "五年以内",
  "五年及以上"
];

const Map<String, int> carPriceMap =const {
  noLimit: 0,
  "5万以下": 1,
  "5-10万": 2,
  "10-15万": 3,
  "15-25万": 4,
  "25-50万": 5,
  "50万以上": 6,
};
const Map<String, int> carAgeMap =const {
  noLimit: 0,
  "一年以内": 1,
  "两年以内": 2,
  "三年以内": 3,
  "四年以内": 4,
  "五年以内": 5,
  "五年及以上": 6,
};