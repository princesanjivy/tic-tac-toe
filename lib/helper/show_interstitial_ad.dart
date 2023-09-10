import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_toe/constants.dart';

class FullScreenAd {
  static final FullScreenAd object = FullScreenAd._internal();

  InterstitialAd? interstitialAd;
  int maxFailedLoadAttempts = 3;
  int numInterstitialLoadAttempts = 0;

  FullScreenAd._internal() {
    _createInterstitialAd();
  }

  factory FullScreenAd() {
    return object;
  }

  void _createInterstitialAd() {
    final ids = [interstitialId1, interstitialId2];
    final random = Random();

    InterstitialAd.load(
      adUnitId: ids[random.nextInt(ids.length)],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          print("Ad Failed to load");
          numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void show() {
    if (interstitialAd == null) {
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );

    interstitialAd!.show();
  }
}
