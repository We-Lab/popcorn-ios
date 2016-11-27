//
//  PCLoginManagerDelegate.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PCSignUpResult) {
    PCSignUpSuccess = 0,
    PCSignUpFailedWithEmail,
    PCSignUpFailedWithNickname,
    PCSignUpFailedWithPassword,
    PCSignUpFailedWithBirthday,
    PCSignUpFailed,
};

@protocol PCLoginManagerDelegate <NSObject>

@optional
// 회원가입
- (void)didSignUpWithFacebook:(BOOL)isSuccess;
- (void)didSignUpWithEmail:(PCSignUpResult)result;

// 로그인
- (void)didSignInWithFacebook:(BOOL)isSuccess;
- (void)didSignInWithEmail:(BOOL)isSuccess;

// 비밀번호 찾기
- (void)didSendPasswordToEmail:(BOOL)isSuccess;

@end
