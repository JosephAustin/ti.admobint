var Admob = require('ti.admobint');

Admob.addEventListener(Admob.AD_RECEIVED, function() {
	Ti.API.info("Ad received");
});
Admob.addEventListener(Admob.AD_NOT_RECEIVED, function(e) {
	Ti.API.info("Ad not received (" + e.error + ")");
});
var ad_data = {
	testDevices: [Admob.SIMULATOR_ID],
};
var banner_view = null;

$.loadbannerbutton.addEventListener('click', function() {
	if(banner_view == null) {
		banner_view = Admob.createBannerView(ad_data);
		$.banner_container.add(banner_view);
	} else {
		banner_view.loadAd(ad_data);
	}
});

$.loadintbutton.addEventListener('click', function() {
	Admob.loadInterstitial(ad_data);
});

$.index.open();
