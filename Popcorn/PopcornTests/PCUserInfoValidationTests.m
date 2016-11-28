//
//  PCUserInfoValidation.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PCUserInfoValidation.h"

@interface PCUserInfoValidationTests : XCTestCase
//@property PCUserInfoValidation validation;
@property NSString *userID;
@property NSString *userPW;
@property NSString *userEmail;
@property NSString *userBirthday;
@property BOOL isValid;

@end

@implementation PCUserInfoValidationTests
@synthesize userID;
@synthesize userPW;
@synthesize userEmail;
@synthesize userBirthday;
@synthesize isValid;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatUserIDLengthOver10OrUnder4ShouldReturnFalse {
    userID = @"String_Lengh_over_10_ID";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertFalse(isValid, @"10자가 넘어가면 False를 반환한다.");
    
    userID = @"ID";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertFalse(isValid, @"4자리 이하 아이디는 False를 반환한다.");
}

- (void)testThatUserIDLengthBetween4and10ShouldReturnTrue {
    userID = @"GoodID";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertTrue(isValid, @"4자리 이상 10자리 이하 아이디는 True를 반환한다.");
}

- (void)testThatUserIDShouldNotBeContainAnyCharacterExceptAlphabetAndNumbers {
    userID = @"No_Underbar";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertFalse(isValid, @"ID에 언더바(_)가 들어가면 안된다.");
    
    userID = @"NOSPECIAL!";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertFalse(isValid, @"ID에 특수문자가 들어가면 안 된다.");
    
    userID = @"한글아이디";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertFalse(isValid, @"ID에 영어,숫자 이외에 다른 언어가 들어가면 안 된다.");
}

- (void)testThatUserIDShouldBeOnlyCombinationOfAlphabetAndNumbers {
    userID = @"ALNUM10";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertTrue(isValid, @"영어와 숫자를 조합한 ID는 가능하다.");
}

- (void)testThatUserEmailShouldBeSatisfiedWithSpecificFormat {
    NSArray *emailList = @[@"mail@text.com", @"mail+filter@test.co.kr", @"mail.format+filter@test.io"];
    for (NSString *email in emailList) {
        isValid = [PCUserInfoValidation isValidEmail:email];
        XCTAssertTrue(isValid, @"이메일 형식을 충족시켜야 한다.");
    }
    
}

- (void)testThatUserEmailShouldNotUseDifferentFormat {
    NSArray *emailList = @[@"email@test@test.com", @"email-!!@test.co.kr", @"email#@test.io"];
    for (NSString *email in emailList) {
        isValid = [PCUserInfoValidation isValidEmail:email];
        XCTAssertFalse(isValid, @"이메일 형식을 충족시켜야 한다.");
    }
}

//- (void)testThatUserAgeShouldBeBetween8and120 {
//    userBirthday = 
//    XCTAssert(<#expression, ...#>)
//}

@end
