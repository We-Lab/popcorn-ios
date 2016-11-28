//
//  PCInitialViewTests.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "PCInitialViewController.h"
#import "PCMainViewController.h"
#import "PCUserInformation.h"

@interface PCInitialViewTests : XCTestCase
@property AppDelegate *app;
@property UIStoryboard *storyboard;
@property PCMainViewController *main;
@property PCInitialViewController *login;
@end

@implementation PCInitialViewTests

- (void)setUp {
    [super setUp];
    self.app = [[AppDelegate alloc] init];
}

- (void)tearDown {
    self.app = nil;
    self.storyboard = nil;
    self.main = nil;
    self.login = nil;
    [PCUserInformation hasUserSignedOut];
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
    [PCUserInformation hasUserSignedOut];
    [self.app application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.login = [self.storyboard instantiateInitialViewController];
    
    XCTAssertEqual(self.app.window.rootViewController.navigationController,
                   self.login.navigationController,
                   @"로그인한 상태에서는 앱 실행 시 로그인뷰로 이동해야 함");
}

- (void)testThatItShouldShowMainViewWhenUserIsSignedIn {
    [PCUserInformation hasUserSignedIn];
    [self.app application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.main = [self.storyboard instantiateInitialViewController];
    
    XCTAssertEqual(self.app.window.rootViewController.navigationController,
                   self.main.navigationController,
                   @"로그인한 상태에서는 앱 실행 시 메인뷰로 이동해야 함");
}

@end
