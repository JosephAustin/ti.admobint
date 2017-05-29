/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAdmobintBannerViewProxy.h"
#import "TiUtils.h"

@implementation TiAdmobintBannerViewProxy

- (TiAdmobintBannerView*)admobView
{
    return (TiAdmobintBannerView*)[self view];
}

- (void)loadAd:(id)properties
{
    [[self admobView] loadAd:properties];
}


@end
