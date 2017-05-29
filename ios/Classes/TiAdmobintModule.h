/** Ti.admob original attribution
 * Copyright (c) 2011 by Studio Classics. All Rights Reserved.
 * Author: Brian Kurzius
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import "TiAdmobintBannerViewProxy.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TiAdmobintModule : TiModule<GADInterstitialDelegate>
{
    GADInterstitial * interstitial;
}

- (void)loadInterstitial:(id)args;
- (TiAdmobintBannerViewProxy*)createBannerView:(id)properties;

@end
