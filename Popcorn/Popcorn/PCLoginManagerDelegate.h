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
    PCSignUpFailedWithID,        // 2자부터 10자, 영어및 숫자
    PCSignUpFailedWithPassword,  // 백엔드가 확인하고 알려주기로
    PCSignUpFailedWithEmail,     // 이메일 인증 -> 추가 기능
    PCSignUpFailedWithPhoneNumber,
    PCSignUpFailed,
};


@protocol PCLoginManagerDelegate <NSObject>

@optional
// 회원가입
- (void)didSignUpWithFacebook:(BOOL)isSuccess;
- (void)didSignUpWithID:(PCSignUpResult)result;

// 로그인
- (void)didSignInWithFacebook:(BOOL)isSuccess;
- (void)didSignInWithID:(NSString *)token;

// 비밀번호 찾기
- (void)didSendPasswordToID:(BOOL)isSuccess;

@end
