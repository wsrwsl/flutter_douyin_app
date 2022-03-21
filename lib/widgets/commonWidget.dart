import 'package:flutter/material.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoadingCircular extends StatelessWidget {
  final double size;
  final Color color;
  final double width;

  const LoadingCircular(
      {this.width = 2, this.size = 16, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: width,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class RadiusContainer extends StatelessWidget {
  final Color color;
  final Widget? child;
  final double height;
  final double radius;
  final double width;
  final double border;
  final Color borderColor;
  final double margin;

  const RadiusContainer(
      {this.color = Colors.blue,
      this.child,
      this.height = 40,
      this.radius = 8,
      this.width = double.infinity,
      this.border = 0,
      this.borderColor = Colors.blue,this.margin=0,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: border,
            color: borderColor,
          )),
      child: child,
    );
  }
}

class FlutterToast {
  static void show(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }
}

class SelectTerm extends StatelessWidget {
  final String? left;
  final String? right;
  final bool isHint;
  final GestureTapCallback? onTap;

  SelectTerm({this.left, this.right, this.onTap, this.isHint = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 14),
          Row(
            children: [
              Text(left ?? "--",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              Text(" : ", style: TextStyle(color: Colors.black, fontSize: 16)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 4, bottom: 4, top: 4),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.black))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          right ?? "--",
                          style: TextStyle(
                              color: isHint ? Colors.grey : Colors.black87,
                              fontSize: 16),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_sharp,
                          color: Colors.black54, size: 16),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DivideLine extends StatelessWidget {
  final double width;
  final Color color;
  final double padding;

  DivideLine({this.width = 0.5, this.color = Colors.black54, this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: width,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: padding),
    );
  }
}

class HindleSelectSheet{
  static Future<String?> hindleSelect(
      {required BuildContext context,
        required int selectType,
        TextEditingController? controller,
        List? list}) async {
    return await showModalBottomSheet<String?>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 12),
                Text("选择${defalutTypeList[selectType]}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                DivideLine(color: Colors.black87),
                SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate((list?.length ?? 0)+1, (index) {
                        if(list!=null&&index==list.length){
                          return SizedBox(height: 8);
                        }
                        if (list![index] == other) {
                          return Padding(
                            padding:
                            EdgeInsets.only(left: 20, right: 6, top: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: other,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.black54)),
                                    ),
                                    controller: controller,
                                  ),
                                ),
                                SizedBox(width: 6),
                                GestureDetector(
                                  child: RadiusContainer(
                                    width: 80,
                                    child: Text(
                                      "确定",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, controller!.text);
                                  },
                                ),
                                SizedBox(width: 12),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, list[index]);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: RadiusContainer(
                                  margin: 16,
                                  color: Colors.white,
                                  border: 0.5,
                                  borderColor: Colors.grey,
                                  child: Text(
                                    list[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
