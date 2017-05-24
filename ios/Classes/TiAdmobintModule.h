#import "TiModule.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TiAdmobintModule : TiModule<GADInterstitialDelegate>
{
    GADInterstitial * interstitial;
    GADRequest *request;
}

- (void)loadInterstitial:(id)args;

@end
