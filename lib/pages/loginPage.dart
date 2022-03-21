import 'package:flutter/material.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/model/commonModel.dart';
import 'package:get/get.dart';
import 'package:tapped/tapped.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';
import 'package:flutter_tiktok/api/commonApi.dart';


import 'homePage.dart';

enum AccountPageType {
  register,
  login,
}

class SignPage extends StatefulWidget {
  AccountPageType pageType;

  SignPage({required this.pageType});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  late TextEditingController controllerName;
  late TextEditingController controllerPass;
  late String pageName;
  RxBool isRegistering = false.obs;
  RxBool isLogining = false.obs;
  RxString loginFail = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    controllerName = TextEditingController();
    controllerPass = TextEditingController();
    pageName = widget.pageType == AccountPageType.register ? '注册' : '登录';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          if (widget.pageType == AccountPageType.register)
            Positioned(
              left: 10,
              top: 10,
              child: Tapped(
                child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pageName,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "请输入您的用户名",
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                    controller: controllerName,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: '请输入您的密码',
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                    cursorColor: Colors.black,
                    controller: controllerPass,
                    obscureText: true,
                  ),
                  Obx(() => loginFail.value != ""
                      ? SizedBox(height: 12)
                      : Container()),
                  Obx(
                    () => loginFail.value != ""
                        ? Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(loginFail.value,
                              style: TextStyle(color: Colors.red)),
                        )
                        : Container(),
                  ),
                  SizedBox(height: 16),
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => isRegistering.value == true
                  ? RadiusContainer(child: LoadingCircular())
                  : _buildButton("注册", () {
                      if (widget.pageType == AccountPageType.login) {
                        jumpToRegister(context);
                      } else if (widget.pageType == AccountPageType.register) {
                        hindleRegister();
                      }
                    }),
            ),
          ),
          if (widget.pageType == AccountPageType.login) SizedBox(width: 20),
          if (widget.pageType == AccountPageType.login)
            Expanded(
              child: Obx(
                () => isLogining.value == true
                    ? RadiusContainer(child: LoadingCircular())
                    : _buildButton("登录", () {
                        hindleLogin(context);
                      }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(
      @required String name, @required GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: RadiusContainer(child: Text(name)),
    );
  }

  void jumpToRegister(BuildContext context){
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) {
      return SignPage(pageType: AccountPageType.register);
    }));
  }
  void jumpToHome(BuildContext context){
    Navigator.pop(context);
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) {
      return HomePage(

      );
    }));
  }
  void hindleRegister() async {
    isRegistering.value = true;
    ResponseResult result = await Api.registerUser(
        name: controllerName.text, pass: controllerPass.text);
    isRegistering.value = false;
    if (result.isSuccess) {
      FlutterToast.show("注册成功");
    } else {
      FlutterToast.show(result.message ?? "注册失败");
    }
  }

  void hindleLogin(BuildContext context) async {
    isLogining.value = true;
    ResponseResult result = await Api.loginUser(
        name: controllerName.text, pass: controllerPass.text);
    isLogining.value = false;
    if (result.isSuccess) {
      FlutterToast.show("登录成功");
      currentUserName=controllerName.text;
      loginFail.value="";
      jumpToHome(context);
    } else {
      loginFail.value = result.message ?? "登录失败";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerName.dispose();
    controllerPass.dispose();
    super.dispose();
  }
}
