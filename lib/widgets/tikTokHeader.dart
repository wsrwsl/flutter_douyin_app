import 'package:flutter/material.dart';
import 'package:flutter_tiktok/api/commonApi.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';
import 'package:get/get.dart';

class TikTokHeader extends StatefulWidget {
  final void Function() setState;
  const TikTokHeader({
    required this.setState,
    Key? key,
  }) : super(key: key);

  @override
  _TikTokHeaderState createState() => _TikTokHeaderState();
}

class _TikTokHeaderState extends State<TikTokHeader> {
  TextEditingController controllerBrand = TextEditingController();
  TextEditingController controllerType = TextEditingController();

  //RxInt selectTypeObs = SelectType.defalut.obs;
  RxString brandObs = defalutTypeList[SelectType.brand].obs;
  RxString typeObs = defalutTypeList[SelectType.type].obs;
  RxString priceObs = defalutTypeList[SelectType.price].obs;
  RxString ageObs = defalutTypeList[SelectType.age].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle selectStyle =
        TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600);
    TextStyle noSelectStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w400);
    return Column(children: [
      Container(
        // color: Colors.black.withOpacity(0.3),
        padding: EdgeInsets.symmetric(horizontal: 11),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //selectTypeObs.value = SelectType.brand;
                      List<String> temp = List.from(carBrand);
                      String? result = await HindleSelectSheet.hindleSelect(
                        context: context,
                        selectType: SelectType.brand,
                        controller: controllerBrand,
                        list: temp,
                      );
                      brandObs.value = result ?? brandObs.value;
                      brandObs.value = brandObs.value == noLimit
                          ? defalutTypeList[SelectType.brand]
                          : brandObs.value;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(brandObs.value,
                          style: brandObs.value ==
                                  defalutTypeList[SelectType.brand]
                              ? noSelectStyle
                              : selectStyle),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //selectTypeObs.value = SelectType.type;
                      List<String> temp = List.from(carType);
                      String? result = await HindleSelectSheet.hindleSelect(
                        context: context,
                        selectType: SelectType.type,
                        controller: controllerType,
                        list: temp,
                      );
                      typeObs.value = result ?? typeObs.value;
                      typeObs.value = typeObs.value == noLimit
                          ? defalutTypeList[SelectType.type]
                          : typeObs.value;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(typeObs.value,
                          style:
                              typeObs.value == defalutTypeList[SelectType.type]
                                  ? noSelectStyle
                                  : selectStyle),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //selectTypeObs.value = SelectType.price;
                      List<String> temp = List.from(carPrice);
                      String? result = await HindleSelectSheet.hindleSelect(
                        context: context,
                        selectType: SelectType.price,
                        list: temp,
                      );
                      priceObs.value = result ?? priceObs.value;
                      priceObs.value = priceObs.value == noLimit
                          ? defalutTypeList[SelectType.price]
                          : priceObs.value;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(priceObs.value,
                          style: priceObs.value ==
                                  defalutTypeList[SelectType.price]
                              ? noSelectStyle
                              : selectStyle),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      //selectTypeObs.value = SelectType.age;
                      List<String> temp = List.from(carAge);
                      String? result = await HindleSelectSheet.hindleSelect(
                        context: context,
                        selectType: SelectType.age,
                        list: temp,
                      );
                      ageObs.value = result ?? ageObs.value;
                      ageObs.value = ageObs.value == noLimit
                          ? defalutTypeList[SelectType.age]
                          : ageObs.value;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(ageObs.value,
                          style: ageObs.value == defalutTypeList[SelectType.age]
                              ? noSelectStyle
                              : selectStyle),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                      await Api.fetchVideo(
                        brand: brandObs.value,
                        type: typeObs.value,
                        price: priceObs.value ,
                        age: ageObs.value,
                      );
                      widget.setState();
                  },
                  child: Container(
                    height: 30,
                    width: 45,
                    alignment: Alignment.center,
                    child: Text(
                      "筛选",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 15),
              ],
            )),
      ),
    ]);
  }
}
