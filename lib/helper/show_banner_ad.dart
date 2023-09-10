import 'dart:math';

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
