//
//  PCLoginManagerTests.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PCUserInformation.h"
#import "PCLoginManager.h"
#import "KeychainItemWrapper.h"

@interface PCLoginManagerTests : XCTestCase <PCLoginManagerDelegate>
@property PCLoginManager *loginManager;
@property PCUserInformation *userInfo;
@property NSString *token;
@property BOOL hasToken;
@end

@implementation PCLoginManagerTests

- (void)setUp {
    [super setUp];
    _userInfo = [[PCUserInformation alloc] init];
    _loginManager = [[PCLoginManager alloc] init];
    _loginManager.delegate = self;
    self.hasToken = NO;
}

- (void)tearDown {
    _userInfo = nil;
    _loginManager = nil;
    [super tearDown];
}

- (void)testThat로그인성공시토큰값을반환받아야한다 {
    [_loginManager signInWithID:@"testuser" andPassword:@"testuser1"];
    [self delayTimeForDelegate:0.5];
    XCTAssertTrue(_hasToken);
}


- (void)didSignInWithID:(NSString *)token {
    if (token) {
        self.hasToken = YES;
        self.token = token;
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
        [keychainItem setObject:_token forKey:(id)kSecAttrAccount];
        [_userInfo setUserTokenFromKeyChain];
    }
}

// delegate 가 제대로 실행된 뒤 테스트할 수 있도록 여유시간 확보
- (void)delayTimeForDelegate:(CGFloat)delay {
    NSDate *delayTime = [NSDate dateWithTimeIntervalSinceNow:delay];
    [[NSRunLoop currentRunLoop] runUntilDate:delayTime];
}

- (void)testThat토큰값은키체인에저장된후유저정보객체가해당값을가지고있어야한다 {
    [_loginManager signInWithID:@"testuser" andPassword:@"testuser1"];
    [self delayTimeForDelegate:0.5];
    XCTAssertTrue([_token isEqualToString:_userInfo.userToken]);
}

- (void)testThat로그인실패시nil값이반환되어야한다 {
    [_loginManager signInWithID:@"Nobody" andPassword:@"nobody1"];
    [self delayTimeForDelegate:0.5];
    XCTAssertNil(_token);
}

//- (void)testThat회원가입에성공하면토큰값을반환받아야한다 {
//    [_loginManager signUpWithID]
//}

@end
