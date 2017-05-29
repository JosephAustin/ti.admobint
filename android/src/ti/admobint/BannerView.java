/** Ti.admob original attribution
 * Copyright (c) 2011 by Studio Classics. All Rights Reserved.
 * Author: Brian Kurzius
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

package ti.admobint;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiUIView;

import android.os.Bundle;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.mediation.admob.AdMobExtras;

public class BannerView extends TiUIView {
	private static final String TAG = "AdMobIntBannerView";
	AdView adView;

  public BannerView(final TiViewProxy proxy) {
		super(proxy);
	}

  public void pause() {
		adView.pause();
	}

	public void resume() {
		adView.resume();
	}

	public void destroy() {
		adView.destroy();
	}

	@Override
	public void processProperties(KrollDict d) {
		super.processProperties(d);
		AdmobintModule.parseProperties(d, "ca-app-pub-3940256099942544/6300978111");

		adView = new AdView(proxy.getActivity());
		adView.setAdSize(AdSize.BANNER);
		adView.setAdUnitId(AdmobintModule.adUnitId);
		adView.setAdListener(new AdListener() {
			public void onAdLoaded() {
				proxy.fireEvent(AdmobintModule.AD_RECEIVED, new KrollDict());
			}

			public void onAdFailedToLoad(int errorCode) {
				proxy.fireEvent(AdmobintModule.AD_NOT_RECEIVED, new KrollDict());
			}
		});
		setNativeView(adView);
		_loadAd();
	}

	private void _loadAd() {
			proxy.getActivity().runOnUiThread(new Runnable() {
				public void run() {
					adView.loadAd(AdmobintModule.createRequest());
				}
			});
	}

	// In case you want to load an ad with different properties in the same view
	public void loadAd(KrollDict d) {
		AdmobintModule.parseProperties(d, "ca-app-pub-3940256099942544/6300978111");
		_loadAd();
	}
}
