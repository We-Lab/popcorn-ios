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
#import "PCNetworkParamKey.h"

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
    [self delayTimeForDelegate:1.0];
    XCTAssertTrue(_hasToken);
}


- (void)didSignInWithID:(NSString *)token {
    if (token) {
        self.hasToken = YES;
        self.token = token;
        
        [_userInfo saveUserToken:token];
    }
}

// delegate 가 제대로 실행된 뒤 테스트할 수 있도록 여유시간 확보
// delay 값을 적게 준 경우 서버 상태에 따라 테스트가 실패하기도 함
- (void)delayTimeForDelegate:(CGFloat)delay {
    NSDate *delayTime = [NSDate dateWithTimeIntervalSinceNow:delay];
    [[NSRunLoop currentRunLoop] runUntilDate:delayTime];
}

- (void)testThat토큰값은키체인에저장된후유저정보객체가해당값을가지고있어야한다 {
    [_loginManager signInWithID:@"testuser" andPassword:@"testuser1"];
    [self delayTimeForDelegate:1.0];
    XCTAssertTrue([_token isEqualToString:_userInfo.userToken]);
}

- (void)testThat로그인실패시nil값이반환되어야한다 {
    [_loginManager signInWithID:@"Nobody" andPassword:@"nobody1"];
    [self delayTimeForDelegate:1.0];
    XCTAssertNil(_token);
}

// 테스트 성공 확인. 반복적인 회원가입이 발생하게 되므로 필요할 때만 테스트 요함.
- (void)Disable_testThat회원가입에성공하면토큰값을반환받아야한다 {
    NSDictionary *form = @{SignUpIDKey:@"testuser10",
                           SignUpPasswordKey:@"testuser10",
                           SignUpConfirmPWKey:@"testuser10",
                           SignUpEmailKey:@"test1@test.co.kr",
                           SignUpBirthdayKey:@"2000-01-01",
                           SignUpPhoneNumberKey:@"000-0000-0000",
                           SignUpGenderKey:@"M"};
    [_loginManager signUpWithID:form];
    
    [self delayTimeForDelegate:0.8];
    XCTAssertTrue(_hasToken);
}


@end
