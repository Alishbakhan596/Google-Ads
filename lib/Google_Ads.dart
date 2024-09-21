import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds extends StatefulWidget {
  const GoogleAds({super.key});

  @override
  State<GoogleAds> createState() => _GoogleAdsState();
}

class _GoogleAdsState extends State<GoogleAds> {
  late BannerAd _bannerAd;
  bool isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: "ca-app-pub-4287173839629229/7515233444",
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(
            () {
              isBannerAdReady = true;
            },
          );
        },
        onAdFailedToLoad: (ad, rrror) {
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    InterstitialAd.load(
      adUnitId: "ca-app-pub-4287173839629229/5049181775",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(
            () {
              _interstitialAd = ad;
              isInterstitialAdReady = true;
            },
          );
        },
        onAdFailedToLoad: (errror) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    if (isBannerAdReady) {
      _interstitialAd.dispose();
    }
    super.dispose();
  }

  void _showInterstitialAd() {
    if (isInterstitialAdReady) {
      _interstitialAd.show();
      _interstitialAd.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        setState(() {
          isInterstitialAdReady = false;
        });

        //load new ad
        InterstitialAd.load(
          adUnitId: "ca-app-pub-4287173839629229/5049181775",
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              setState(
                () {
                  _interstitialAd = ad;
                  isInterstitialAdReady = true;
                },
              );
            },
            onAdFailedToLoad: (errror) {
              isInterstitialAdReady = false;
            },
          ),
        );
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        setState(() {
          isInterstitialAdReady = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Google Ads",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic, fontSize: 25),
          ),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  //   _showInterstitialAd();
                  // ));
                  _showInterstitialAd();
                },
                child: Text(
                  "Show Ad",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isBannerAdReady
            ? SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : null);
  }
}
