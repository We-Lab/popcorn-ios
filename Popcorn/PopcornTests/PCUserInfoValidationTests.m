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
    XCTAssertFalse(isValid, @"4자리 미만 아이디는 False를 반환한다.");
}

- (void)testThatUserIDLengthBetween4and10ShouldReturnTrue {
    userID = @"GoodID";
    isValid = [PCUserInfoValidation isValidID:userID];
    XCTAssertTrue(isValid, @"아이디는 4자리 이상 10자리 이하여야 한다.");
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

- (void)testThatUserPWLengthBetween6and15ShouldReturnTrue {
    userPW = @"TestPassword123";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertTrue(isValid, @"아이디는 6자리 이상 15자리 이하여야 한다.");
}

- (void)testThatUserPWLengthIsNotBetween6and15ShouldReturnFalse {
    userPW = @"TestP";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertFalse(isValid, @"5자리 이하 비밀번호는 입력할 수 없다.");
    
    userPW = @"TestPassword1234";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertFalse(isValid, @"15자리를 초과하는 비밀번호는 입력할 수 없다.");
}

- (void)testThat유저비번에알파벳과숫자는각각1개이상조합되어야한다 {
    userPW = @"AlphabetONLY";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertFalse(isValid, @"숫자가 최소 1개 이상 조합되어야 한다.");
    
    userPW = @"NumberONLY";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertFalse(isValid, @"알파벳이 최소 1개 이상 조합되어야 한다.");
}

- (void)testThatUserPWCombinedAlphabetAndNumberShouldReturnTrue {
    userPW = @"alphabet1234";
    isValid = [PCUserInfoValidation isValidPW:userPW];
    XCTAssertTrue(isValid, @"영문자+숫자가 조합된 아이디는 통과된다.");
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
