import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class BannerInsideList extends StatefulWidget {
  final List<String> items = List<String>.generate(10000, (i) => 'Item $i');

  @override
  State createState() => _BannerInsideListState();
}

class _BannerInsideListState extends State<BannerInsideList> {
  static final _adAfter = 5;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // COMPLETE: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner Ad Inside ListView'),
        backgroundColor: const Color(0xff764abc),
      ),
      body: ListView.builder(
        itemCount: widget.items.length + (_isBannerAdReady ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isBannerAdReady && index == _adAfter) {
            return Container(
              child: AdWidget(ad: _bannerAd),
              width: _bannerAd.size.width.toDouble(),
              height: 72.0,
              alignment: Alignment.center,
            );
          } else {
            final item = widget.items[_getItemIndex(index)];
            return ListTile(
              title: Text(item),
              onTap: () {
                print('Clicked ${item}');
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  int _getItemIndex(int rawIndex) {
    if (rawIndex >= _adAfter && _isBannerAdReady) {
      return rawIndex - 1;
    }
    return rawIndex;
  }
}
