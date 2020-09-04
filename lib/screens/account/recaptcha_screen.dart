import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';


class RecaptchaV2 extends StatefulWidget {
  final String apiKey = Config.captchaApiKey;
  final String pluginURL = Config.captchaUrl;
  final RecaptchaV2Controller controller;
  final ValueChanged<String> onTokenReceived;

  RecaptchaV2({
    RecaptchaV2Controller controller,
    this.onTokenReceived,
  }) : controller = controller ?? RecaptchaV2Controller();

  @override
  State<StatefulWidget> createState() => _RecaptchaV2State();
}

class _RecaptchaV2State extends State<RecaptchaV2> {
  RecaptchaV2Controller controller;
  WebViewController webViewController;
  bool _isLoading = false;

  void onListen() {
    if (controller.visible) {
      if (webViewController != null) {
        webViewController.clearCache();
        webViewController.reload();
      }
    }
    setState(() {
      controller.visible;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    controller = widget.controller;
    controller.addListener(onListen);
    super.initState();
  }

  @override
  void didUpdateWidget(RecaptchaV2 oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(onListen);
      controller = widget.controller;
      controller.removeListener(onListen);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.removeListener(onListen);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.visible
        ? Scaffold(
      backgroundColor: App.theme.colors.background,
      appBar: AppBarWidget(
        'reCAPTCHA',
        leadingButton: Padding(
          padding: EdgeInsets.only(left: 15),
          child: GestureDetector(
              onTap: () {
                controller.hide();
              },
              child: Icon(
                Icons.close,
                size: 30,
              )),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: "${widget.pluginURL}?api_key=${widget.apiKey}",
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: 'RecaptchaFlutterChannel',
                  onMessageReceived: (JavascriptMessage receiver) {
                    String _token = receiver.message;
                    if (_token.contains("verify")) {
                      _token = _token.substring(7);
                    }
                    widget.controller.hide();
                    widget.onTokenReceived(_token);
                  },
                ),
              ].toSet(),
              onWebViewCreated: (_controller) {
                webViewController = _controller;
              },
              onPageFinished: (strURL) => {
                setState(() {
                  _isLoading = false;
                })
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      LocaleKeys.verification_code_please_help_us_verify_you_are_not_a.tr(),
                      style: App.theme.styles.body1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : Container();
  }
}

class RecaptchaV2Controller extends ChangeNotifier {
  bool isDisposed = false;
  List<VoidCallback> _listeners = [];

  bool _visible = false;
  bool get visible => _visible;

  void show() {
    _visible = true;
    if (!isDisposed) notifyListeners();
  }

  void hide() {
    _visible = false;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _listeners = [];
    isDisposed = true;
    super.dispose();
  }

  @override
  void addListener(listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(listener) {
    _listeners.remove(listener);
    super.removeListener(listener);
  }
}
