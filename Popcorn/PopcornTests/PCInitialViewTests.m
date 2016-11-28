//
//  PCInitialViewTests.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "PCUserInformation.h"
#import "PCMainViewController.h"

@interface PCInitialViewTests : XCTestCase
@end

@implementation PCInitialViewTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatItShouldReturnNOWhenUserhasSignedIn {
    [PCUserInformation hasUserSignedIn];
    BOOL isUserSignedIn = [PCUserInformation isUserSignedIn];
    XCTAssertTrue(isUserSignedIn, @"로그인 이후에는 YES를 반환해야 함");
}

- (void)testThatItShouldReturnNOWhenUserhasSignedOut {
    [PCUserInformation hasUserSignedOut];
    BOOL isUserSignedIn = [PCUserInformation isUserSignedIn];
    XCTAssertFalse(isUserSignedIn, @"로그아웃 이후에는 NO를 반환해야 함");
}

- (void)testThatItShouldShowLoginViewWhenUserIsNotSignedIn {
}

- (void)testThatItShouldShowMainViewWhenUserIsSignedIn {
    [PCUserInformation hasUserSignedIn];
    AppDelegate *app = [[AppDelegate alloc] init];
    [app application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PCMainViewController *vc = [storyboard instantiateInitialViewController];
 
    XCTAssertEqual(app.window.rootViewController.navigationController, vc.navigationController);
}

@end
