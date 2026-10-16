import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:auth_totp/auth_totp.dart';

import 'package:tu_login/core/file_downloader.dart';
import 'package:tu_login/ui/scaffold_messenger/scaffold_messenger_controller.dart';

class WebviewAutologin extends StatefulWidget {
  final String initialUrl;
  final String zihLoginUsername;
  final String zihLoginPassword;
  final String zihLoginTotpSecret;

  const WebviewAutologin({
    required this.initialUrl,
    required this.zihLoginUsername,
    required this.zihLoginPassword,
    required this.zihLoginTotpSecret,
    super.key,
  });

  @override
  State<WebviewAutologin> createState() => _WebviewAutologinState();
}

class _WebviewAutologinState extends State<WebviewAutologin> {
  late InAppWebViewController webViewController;
  TextEditingController searchBar = TextEditingController();
  bool isNewURL = false;
  String newURL = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
          return;
        } else {
          webViewController.webStorage.sessionStorage.clear();
          navigator.pop('');
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black45,
            ),
            width: double.infinity,
            alignment: Alignment.center,
            height: 30,
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 10),
              ),
              onChanged: (value) {
                isNewURL = true;
                newURL = value;
              },
              controller: searchBar,
              style: const TextStyle(fontSize: 15),
              autocorrect: false,
              onSubmitted: (value) {
                webViewController.loadUrl(
                  urlRequest: URLRequest(url: WebUri(value)),
                );
              },
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, searchBar.text);
              },
              icon: const Icon(Icons.close, size: 30),
            ),
          ],
        ),
        body: InAppWebView(
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
          initialSettings: InAppWebViewSettings(
            forceDark: ForceDark.ON,
            algorithmicDarkeningAllowed: true,
            incognito: true,
            userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            preferredContentMode: UserPreferredContentMode.DESKTOP,

            useWideViewPort: true,
            loadWithOverviewMode: true,
            builtInZoomControls: true,
            supportZoom: true,
            displayZoomControls: false,
          ),
          onLoadStart: (controller, url) {
            setState(() {
              searchBar.text = url.toString();
            });
          },
          onLoadStop: (controller, url) {
            if (url.toString().contains('navigator.tu-dresden.de')) {
              final String jsChangeView =
                  '''var style = document.createElement('style');
                  style.innerHTML = `html, body, #portal-wrapper, #portal-main {
                      max-width: 100% !important;
                      overflow-x: hidden !important;
                      box-sizing: border-box !important;
                    }`;
                  document.head.appendChild(style);

                  var targetWidth = 900;
                  var screenWidth = window.innerWidth || document.documentElement.clientWidth || screen.width;
                  var scale = screenWidth / targetWidth;

                  var meta = document.querySelector('meta[name="viewport"]');
                  if (meta) {
                    meta.setAttribute('content', 'width=' + targetWidth + ', initial-scale=' + scale + ', minimum-scale=0.1, maximum-scale=5.0, user-scalable=yes');
                  } else {
                    var newMeta = document.createElement('meta');
                     newMeta.name = 'viewport';
                    newMeta.content = 'width=' + targetWidth + ', initial-scale=' + scale + ', minimum-scale=0.1, maximum-scale=5.0, user-scalable=yes';
                    document.head.appendChild(newMeta);
                  }''';

              // login Raumbelegungsplan
              final String jsLoginRoomPlan = '''const dialogbutton = document.getElementsByClassName('login')[1];
                  const submitbutton = document.getElementsByClassName('login')[0];
                  const userfield = document.getElementsByName('user')[0];
                  const passwordfield = document.getElementsByName('passwd')[0];

                  userfield.value = '${widget.zihLoginUsername}';
                  passwordfield.value = '${widget.zihLoginPassword}';

                  dialogbutton.addEventListener('click', () => {
                  submitbutton.click(); });
                  ''';

              webViewController.evaluateJavascript(source: jsChangeView);
              webViewController.evaluateJavascript(source: jsLoginRoomPlan);
            }

            // login for zih portal
            if (url.toString().contains('idp.tu-dresden.de')) {
              String generatedTOTPCode = AuthTOTP.generateTOTPCode(
                secretKey: widget.zihLoginTotpSecret,
                interval: 30,
                digits: 6,
              );

              final String jsLoginIdp =
                  '''if (document.getElementById('username')!=null) {
                  document.getElementById('username').value = '${widget.zihLoginUsername}';
                  document.getElementById('password').value = '${widget.zihLoginPassword}';
                  document.getElementsByName('_eventId_proceed')[0].click();}
                  if (document.getElementById('fudis_otp_input')!=null) {
                  document.getElementById('fudis_otp_input').value = '$generatedTOTPCode';
                  document.getElementsByName('_eventId_proceed')[0].click();
                  }''';

              webViewController.evaluateJavascript(source: jsLoginIdp);
            }

            // login to selma portal
            if (url.toString().contains('selma.tu-dresden.de')) {
              final String jsLoginSelma =
                  '''if (document.getElementById('logIn_btn').value == 'Anmelden') {
                  document.getElementById('field_user').value = '${widget.zihLoginUsername}';
                  document.getElementById('field_pass').value = '${widget.zihLoginPassword}';
                  document.getElementById('logIn_btn').click();
                  }''';

              webViewController.evaluateJavascript(source: jsLoginSelma);
            }

            // login to opal (selecting tu dresden and proceeding)
            if (url.toString().contains('bildungsportal.sachsen.de/opal/')) {
              final String jsLoginOpal =
                  '''if (document.getElementById('id12').name == 'shibLogin') {
                  document.getElementById('id2').value = 13;
                  document.getElementById('id12').click();
                  }''';

              webViewController.evaluateJavascript(source: jsLoginOpal);
            }
          },
          onDownloadStartRequest: (controller, downloadStartRequest) async {
            CookieManager cookieManager = CookieManager.instance();
            List<Cookie> cookies = await cookieManager.getCookies(
              url: downloadStartRequest.url,
            );

            String cookieString = cookies
                .map((cookie) => '${cookie.name}=${cookie.value}')
                .join('; ');

            Map<String, String> headers = {'Cookie': cookieString};
            print(cookies);
            print(downloadStartRequest.url.toString());
            print('${downloadStartRequest.suggestedFilename}_${DateTime.now()}');
            ScaffoldMessengerController(context: context, displayDuration: Duration(seconds: 3)).showMessage('Downloading ${downloadStartRequest.suggestedFilename}');
            await FileDownloader.byUrl(
              downloadStartRequest.url.toString(),
              downloadStartRequest.suggestedFilename ??
                  'tu_login_download_${DateTime.now().toString()}',
              headers,

            );
          },
        ),
      ),
    );
  }
}
