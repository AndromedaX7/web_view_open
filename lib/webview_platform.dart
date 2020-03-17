import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewopen/webviewopen.dart';

class WebViewWrapper extends StatefulWidget {
  final String content;

  WebViewWrapper(this.content);

  @override
  _WebViewWrapperState createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  @override
  Widget build(BuildContext context) {
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return Container(
          child: GestureDetector(
            child: Container(
              width: double.infinity,
              height: 50,
              child: Card(
                child: Center(
                  child: Text("点我查看详情"),
                ),
              ),
            ),
            onTap: () {
              Webviewopen.toDetails(widget.content);
            },
          ),
        );
      } else if (Platform.isAndroid || Platform.isIOS) {
        return WebViewProgress(widget.content);
//        return Container();
      } else {
        print("fuchsia");
        return Container(
          child: GestureDetector(
            child: Container(
              width: double.infinity,
              height: 50,
              child: Card(
                child: Center(
                  child: Text("点我查看详情"),
                ),
              ),
            ),
            onTap: () {
              Webviewopen.toDetails(widget.content);
            },
          ),
        );
      }
    } catch (e) {
      print(e);
      return Container(
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              child: Center(
                child: Text("点我查看详情"),
              ),
            ),
          ),
          onTap: () {
            Webviewopen.toDetails(widget.content);
          },
        ),
      );
    }
  }
}

class WebViewProgress extends StatefulWidget {
  final String content;

  WebViewProgress(this.content) ;

  @override
  _WebViewProgressState createState() => _WebViewProgressState();
}

class _WebViewProgressState extends State<WebViewProgress> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  @override
  void initState() {
    super.initState();
    try {
      _controller.future.then((value) {
        String contentBase64 =
        base64Encode(const Utf8Encoder().convert(htmlWrapper(widget.content)));
        setState(() {
          value.loadUrl('data:text/html;base64,$contentBase64');
        });


      });
    } catch (e) {
      print("hasErr");
    }
  }

  double htmlHeight = 667;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: htmlHeight,
      child: Builder(
        builder: (c){
          return  WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (w) {
              _controller.complete(w);
            },
            onPageFinished: (url) {
              _controller.future.then((value) async {
                final scrollHeight =
                await value.evaluateJavascript(
                    '(() => document.body.scrollHeight)();');
                if (scrollHeight != null) {
                  setState(() {
                    htmlHeight =
                        double.parse(scrollHeight);
                    print(htmlHeight);
                  });
                }
              });
            },
          );
        },
      )
    );
  }

  String htmlWrapper(String content) {
    String result = "<html>\n" +
        "    <head>\n" +
        "        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n" +
        "    </head>\n" +
        "    <body>\n" +
        content. replaceAll(RegExp("width:([ ]*)([0-9]*px)"), "width:100%")  +
        "    </body>\n" +
        "</html>";
    return result;
  }
}