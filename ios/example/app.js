// All options passed to loadInterstitial are optional.
var ads = require("ti.admobint");

ads.loadInterstitial({
  // So that your simulator is a tester
	testDevices: [ads.SIMULATOR_ID],

  // For targeting ads
	keywords: ["technology", "mobile"],

  // If you don't supply this it will default to a test-only unit
	adUnitId: OS_IOS ? '<< ios co-app-pub-xxxx id >>' : '<< android co-app-pub-xxxx id >>'
});

// Yes that's all you do.

// You should also checkout the example application to see how banners work.
