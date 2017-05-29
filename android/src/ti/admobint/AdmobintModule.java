/** Ti.admob original attribution
* Copyright (c) 2011 by Studio Classics. All Rights Reserved.
* Author: Brian Kurzius
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
*/

package ti.admobint;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;

import org.appcelerator.titanium.TiApplication;

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
	@Kroll.constant
	public static final int GENDER_MALE = AdRequest.GENDER_MALE;
	@Kroll.constant
	public static final int GENDER_FEMALE = AdRequest.GENDER_FEMALE;
	@Kroll.constant
	public static final int GENDER_UNKNOWN = AdRequest.GENDER_UNKNOWN;

	// Parameters for ads - set statically so they can be shared by module and banner view
	public static String adUnitId;
	public static ArrayList<String> devices;
	public static ArrayList<String> keywords;
	public static int gender;

	public AdmobintModule() {
		super();
	}

	// From a kroll dictionary, get the request properties
	public static void parseProperties(KrollDict d, String default_ad_id) {
		adUnitId = default_ad_id;
		devices = new ArrayList<String>();
		keywords = new ArrayList<String>();
		gender = AdRequest.GENDER_UNKNOWN;

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
		if (d.containsKey("gender")) {
			gender = d.getInt("gender");
		}
	}

	// The current properties in form of a request
	public static AdRequest createRequest() {
		AdRequest.Builder adRequestBuilder = new AdRequest.Builder();

		for(String device : devices) {
			adRequestBuilder.addTestDevice(device);
		}
		for(String keyword : keywords) {
			adRequestBuilder.addKeyword(keyword);
		}
		adRequestBuilder.setGender(gender);

		return adRequestBuilder.build();
	}

	@Kroll.method
	public void loadInterstitial(KrollDict d) {
		parseProperties(d, "ca-app-pub-3940256099942544/1033173712");

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
				interstitial.loadAd(createRequest());
			}
		});
	}
}
