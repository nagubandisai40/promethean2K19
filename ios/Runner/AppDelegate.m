#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSServices provideAPIKey: @"AIzaSyDeKtcfAxgn-VbDwv0nbaM4UnZIhV7aufw"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
