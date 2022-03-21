import 'package:flutter/material.dart';
import 'package:flutter_tiktok/widgets/commonWidget.dart';

class PopupWidget extends StatefulWidget {
  final String title;
  final String text;
  final String cancelTitle;
  final bool existConfirm;
  final Widget? confirmWidget;

  PopupWidget({
    this.title = "提示",
    required this.text,
    this.cancelTitle = "取消",
    this.existConfirm = false,
    this.confirmWidget,
  });

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          if (mounted) {
            Navigator.pop(context);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        widget.text,
                        style: TextStyle(color: Colors.black,fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    DivideLine(padding: 16),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.cancelTitle,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        if (widget.existConfirm == true)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            height: 20,
                            width: 0.5,
                            color: Colors.black54,
                          ),
                        if (widget.existConfirm == true)
                          Expanded(
                            child: widget.confirmWidget!,
                          )
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
