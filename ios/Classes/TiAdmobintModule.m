#import "TiAdmobintModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "TiUtils.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

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

- (void)loadInterstitial:(id)args
{
    ENSURE_ARG_COUNT(args, 1);
    RELEASE_TO_NIL(interstitial);

    // Defaults
    NSArray * devices = @[];
    NSArray * keywords = @[];
    NSString * adUnitId = @"ca-app-pub-3940256099942544/1033173712";

    // Parse
    NSDictionary * params = [args objectAtIndex:0];
    if([params objectForKey: @"testDevices"]) {
        devices = [params objectForKey: @"testDevices"];
    }
    if([params objectForKey: @"adUnitId"]) {
        adUnitId = [params objectForKey: @"adUnitId"];
    }
    if([params objectForKey: @"keywords"]) {
        keywords = [params objectForKey: @"keywords"];
    }

    interstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
    [interstitial setDelegate:self];

    request = [GADRequest request];
    [request setTestDevices:devices];
    [request setKeywords:keywords];

    [interstitial loadRequest:request];
}


- (NSDictionary *)dictionaryFromInterstitial:(GADInterstitial *)_interstitial
{
    return @{
       @"adUnitId": _interstitial.adUnitID,
       @"isReady": NUMBOOL(_interstitial.isReady)
     };
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
    RELEASE_TO_NIL(request);
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

@end
