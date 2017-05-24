package ti.admobint;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;

import org.appcelerator.titanium.TiApplication;

import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdListener;

import java.util.ArrayList;

import android.app.Activity;

@Kroll.module(name = "Admobint", id = "ti.admobint")
public class AdmobintModule extends KrollModule {
	private static final String TAG = "AdmobintModule";
	public static String MODULE_NAME = "AndroidAdmobintModule";

	@Kroll.constant
	public static final String AD_RECEIVED = "didReceiveAd";
	@Kroll.constant
	public static final String AD_NOT_RECEIVED = "didFailToReceiveAd";
	@Kroll.constant
	public static final String SIMULATOR_ID = "B3EEABB8EE11C2BE770B684D95219ECB";

	public AdmobintModule() {
		super();
	}

	@Kroll.method
	public void loadInterstitial(KrollDict d) {
		String adUnitId = "ca-app-pub-3940256099942544/1033173712";
		final ArrayList<String> devices = new ArrayList<String>();
		final ArrayList<String> keywords = new ArrayList<String>();

		if (d.containsKey("adUnitId")) {
			adUnitId = d.getString("adUnitId");
		}
		if (d.containsKey("testDevices")) {
			for(String device : d.getStringArray("testDevices")) {
				devices.add(device);
			}
		}
		if (d.containsKey("keywords")) {
			for(String keyword : d.getStringArray("keywords")) {
				keywords.add(keyword);
			}
		}

		final InterstitialAd interstitial = new InterstitialAd(TiApplication.getAppCurrentActivity());
		interstitial.setAdUnitId(adUnitId);

		// set the listener
		interstitial.setAdListener(new AdListener() {
			public void onAdLoaded() {
				fireEvent(AD_RECEIVED, new KrollDict());
				interstitial.show();
			}

			public void onAdFailedToLoad(int errorCode) {
				fireEvent(AD_NOT_RECEIVED, new KrollDict());
			}
		});

		TiApplication.getAppCurrentActivity().runOnUiThread(new Runnable() {
			public void run() {
				final AdRequest.Builder adRequestBuilder = new AdRequest.Builder();

				for(String device : devices) {
					adRequestBuilder.addTestDevice(device);
				}
				for(String keyword : keywords) {
					adRequestBuilder.addKeyword(keyword);
				}

				interstitial.loadAd(adRequestBuilder.build());
			}
		});
	}
}
