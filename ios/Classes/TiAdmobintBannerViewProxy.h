/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiViewProxy.h"
#import "TiAdmobintBannerView.h"

@interface TiAdmobintBannerViewProxy : TiViewProxy {}

- (TiAdmobintBannerView*)admobView;
- (void)loadAd: (id)properties;

@end
