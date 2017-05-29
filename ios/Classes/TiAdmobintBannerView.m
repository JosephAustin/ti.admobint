/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAdmobintBannerView.h"
#import "TiAdmobintModule.h"
#import "TiApp.h"
#import "TiUtils.h"

@implementation TiAdmobintBannerView

#pragma mark - Ad Lifecycle

-(void)setAd:(id)value
{
    NSString *str = [TiUtils stringValue:value];
}

- (GADBannerView *)bannerView
{
    if (bannerView == nil) {
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
        [bannerView setDelegate:self];
        [bannerView setRootViewController:[[TiApp app] controller]];
        
        [self addSubview:[self bannerView]];
    }
    
    return bannerView;
}

- (void)initialize
{
    ENSURE_UI_THREAD_0_ARGS
    [[self bannerView] setAdUnitID:[TiAdmobintModule adUnitID]];
    [[self bannerView] loadRequest:[TiAdmobintModule createRequest]];
}

- (void)dealloc
{
    if (bannerView != nil) {
        [bannerView removeFromSuperview];
    }

    RELEASE_TO_NIL(bannerView);

    [super dealloc];
}

- (void)loadAd:(id)properties
{
    [TiAdmobintModule parseProperties:properties default_ad_id:@"ca-app-pub-3940256099942544/6300978111"];
    [self initialize];
}

- (NSDictionary *)dictionaryFromBannerView:(GADBannerView *)bannerView
{
    return @{
             @"adUnitId": bannerView.adUnitID
             };
}

#pragma mark - Ad Delegate

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    [self.proxy fireEvent:@"didReceiveAd" withObject:[self dictionaryFromBannerView:view]];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self.proxy fireEvent:@"didFailToReceiveAd" withObject:@{@"adUnitId": view.adUnitID, @"error":error.localizedDescription}];
}

@end
