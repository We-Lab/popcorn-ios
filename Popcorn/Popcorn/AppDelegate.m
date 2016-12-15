//
//  AppDelegate.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "AppDelegate.h"

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PCUserInformation.h"

@interface AppDelegate ()

@end

typedef NS_ENUM(NSUInteger, MainInterfaceView) {
    APPMainInterfaceViewRelease = 1,
    APPMainInterfaceViewMain,
    APPMainInterfaceViewMovieInfo,
};

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//                             didFinishLaunchingWithOptions:launchOptions];
//    [self configureGA];
    
    
    MainInterfaceView initialView = APPMainInterfaceViewMovieInfo
    ;
    switch (initialView) {
        case APPMainInterfaceViewRelease:
            [self selectInitialViewController];
            break;
        case APPMainInterfaceViewMain:
            [self selectInitialViewByForce:@"Main"];
            break;
        case APPMainInterfaceViewMovieInfo:
            [self selectInitialViewByForce:@"MovieInfo"];
            break;
        default:
            [self selectInitialViewByForce:@"Login"];
    }

    return YES;
}

//- (void)configureGA {
//    NSError *configureError;
//    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//    
//    GAI *gai = [GAI sharedInstance];
//    [gai trackerWithTrackingId:@"UA-88607624-1"];
//    gai.trackUncaughtExceptions = YES;
//    gai.dispatchInterval = 20;
//    
//    // remove before app release  
//    gai.logger.logLevel = kGAILogLevelVerbose;
//}

// 기본값은 Login Storyboard, 로그인 상태면 Main Storyboard
- (void)selectInitialViewController {
    BOOL isUserSignedIn = [PCUserInformation isUserSignedIn];
    if ( isUserSignedIn ) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [[PCUserInformation userInfo] setUserTokenFromKeyChain];
    }
}

- (void)selectInitialViewByForce:(NSString *)storyboardName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
}


//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
