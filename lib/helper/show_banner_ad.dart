// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_toe/constants.dart';

class BottomBannerAd {
  late BannerAd _bannerAd;

  BottomBannerAd() {
    if (!kIsWeb) {
      _initBannerAd();
    }
  }

  void _initBannerAd() {
    final ids = [bannerId1, bannerId2];
    final random = Random();

    _bannerAd = BannerAd(
      adUnitId: ids[random.nextInt(ids.length)],
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(
          // onAdLoaded: (ad) {
          //   _isLoaded = true;
          // },
          ),
    );

    _bannerAd.load();
  }

  // Widget bannerForWeb() {
  //   // ignore: undefined_prefixed_name
  //   ui.platformViewRegistry.registerViewFactory(
  //       "bannerAd",
  //       (int viewID) => IFrameElement()
  //         ..width = "468"
  //         ..height = "60"
  //         ..src = "adsterra_banner_ad.html"
  //         ..style.border = "none");

  //   return const SizedBox(
  //     height: 60,
  //     width: 468,
  //     child: HtmlElementView(
  //       viewType: "bannerAd",
  //     ),
  //   );
  // }

  Widget showBanner() {
    return kIsWeb
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            height: 26,
            child: const Text(
              "Copyright © princeappstudio.in",
              style: TextStyle(
                color: Colors.cyan,
              ),
            ),
          )
        // ? bannerForWeb()
        : Container(
            alignment: Alignment.center,
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(
              ad: _bannerAd,
            ),
          );
  }
}
