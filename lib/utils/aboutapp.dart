import 'package:flutter/gestures.dart';
// import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

// import 'package:url_launcher/url_launcher.dart';

class _LinkTextSpan extends TextSpan {


  _LinkTextSpan({ TextStyle style, String url, String text }) : super(
    style: style,
    text: text ?? url,
    recognizer: TapGestureRecognizer()..onTap = () {
      // launch(url, forceSafariVC: false);
    }
  );
}

void showGalleryAboutDialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = TextStyle(fontFamily: 'QuickSand',fontSize: 16.0,color: Colors.black);
  final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

  showAboutDialog(
    context: context,
    applicationVersion: 'Promethean 2k19',
    applicationIcon: const FlutterLogo(),
    applicationLegalese: '© BV Raju Institute of Technology',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                style: aboutTextStyle,
                text: 'Promethean is the biggest Annual Technical Symposium of BVRIT '
                      ' continuing the Saga this Year also, It is ready To Hit You with All-New Events, '
                      // '${defaultTargetPlatform == TargetPlatform.iOS ? 'multiple platforms' : 'iOS and Android'} '
                      "Workshops,With Exciting Prize Money And Lots More. So Don't Miss The Chance Get Registered Yourselves Today ",
              ),
              _LinkTextSpan(
                style: linkStyle,
                url: 'https://bvrit.ac.in',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '.\n',
              ),
              _LinkTextSpan(
                style: linkStyle,
                url: 'http://www.bvrit.ac.in',
                text: 'Visit College Official Website',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '.',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
