//
//  PCLoginManagerDelegate.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PCSignUpResult) {
    PCSignUpSuccess = 201,
    PCSignUpFailed = 400,
    PCSignUpServerError = 500,
};


@protocol PCLoginManagerDelegate <NSObject>

@optional
// 회원가입
- (void)didSignUpWithFacebook:(BOOL)isSuccess;
- (void)didSignUpWithID:(PCSignUpResult)statusCode andResponseObject:(NSDictionary *)responseObject;

// 로그인
- (void)didSignInWithFacebook:(BOOL)isSuccess;
- (void)didSignInWithID:(NSString *)token;

// 비밀번호 찾기
- (void)didSendPasswordToID:(BOOL)isSuccess;

@end
