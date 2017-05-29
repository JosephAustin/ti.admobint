/** Ti.admob original attribution
 * Copyright (c) 2011 by Studio Classics. All Rights Reserved.
 * Author: Brian Kurzius
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAdmobintModule.h"
#import "TiApp.h"

// Parameters for ads - set statically so they can be shared by module and banner view
static NSString * adUnitId = nil;
static NSArray * devices = nil;
static NSArray * keywords = nil;
static GADGender gender = kGADGenderUnknown;

// For ios i need this static as well as it is constructed whenever used through
// a static method
static GADRequest * request = nil;

@implementation TiAdmobintModule

-(id)moduleGUID
{
	return @"9f57138e-b6cb-4804-a5c9-d8a7898e43d3";
}

-(NSString*)moduleId
{
	return @"ti.admobint";
}

#pragma mark Lifecycle

-(void)startup
{
    [super startup];
}

-(void)shutdown:(id)sender
{
    [super shutdown:sender];
}

// From a kroll dictionary, get the request properties
+ (void)parseProperties:(id)args default_ad_id:(NSString*)default_ad_id
{
  adUnitId = default_ad_id;
  devices = @[];
  keywords = @[];
  GADGender gender = kGADGenderUnknown;

  NSDictionary * params = [args objectAtIndex:0];
  if([params objectForKey: @"adUnitId"]) {
      adUnitId = [params objectForKey: @"adUnitId"];
  }
  if([params objectForKey: @"testDevices"]) {
      devices = [params objectForKey: @"testDevices"];
  }
  if([params objectForKey: @"keywords"]) {
      keywords = [params objectForKey: @"keywords"];
  }
  if([params objectForKey: @"gender"]) {
      gender = [params objectForKey: @"gender"];
  }
}

// The current properties in form of a request
+ (GADRequest*)createRequest
{
  request = [GADRequest request];
  [request setTestDevices:devices];
  [request setKeywords:keywords];
  [request setGender:gender];
  return request;
}

+ (NSString*)adUnitID
{
    return adUnitId;
}

- (void)loadInterstitial:(id)args
{
    ENSURE_ARG_COUNT(args, 1);
    RELEASE_TO_NIL(interstitial);

    [TiAdmobintModule parseProperties: args default_ad_id:@"ca-app-pub-3940256099942544/1033173712"];

    interstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
    [interstitial setDelegate:self];

    [interstitial loadRequest:[TiAdmobintModule createRequest]];
}


- (NSDictionary *)dictionaryFromInterstitial:(GADInterstitial *)_interstitial
{
    return @{
       @"adUnitId": _interstitial.adUnitID,
       @"isReady": NUMBOOL(_interstitial.isReady)
     };
}

- (TiAdmobintBannerViewProxy*)createBannerView:(id)properties
{
    TiAdmobintBannerViewProxy * bv = [[TiAdmobintBannerViewProxy alloc] init];
    [bv loadAd:properties];
    return bv;
}

#pragma mark - Interstitial Delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
   [self fireEvent:@"didReceiveAd" withObject:[self dictionaryFromInterstitial:ad]];
   if ([interstitial isReady]) {
       [interstitial presentFromRootViewController:[[[TiApp app] controller] topPresentedController]];
   }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self fireEvent:@"didFailToReceiveAd" withObject:@{@"adUnitId": ad.adUnitID, @"error":error.localizedDescription}];
}

#pragma mark Cleanup

-(void)dealloc
{
    RELEASE_TO_NIL(interstitial);
    [super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Constants

MAKE_SYSTEM_STR(AD_RECEIVED, @"didReceiveAd");
MAKE_SYSTEM_STR(AD_NOT_RECEIVED, @"didFailToReceiveAd");
MAKE_SYSTEM_STR(SIMULATOR_ID, kGADSimulatorID);
MAKE_SYSTEM_PROP(GENDER_MALE, kGADGenderMale);
MAKE_SYSTEM_PROP(GENDER_FEMALE, kGADGenderFemale);
MAKE_SYSTEM_PROP(GENDER_UNKNOWN, kGADGenderUnknown);

@end
