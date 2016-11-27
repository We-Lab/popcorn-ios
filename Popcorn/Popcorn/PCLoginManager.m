//
//  PCLoginManager.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCLoginManager.h"

@implementation PCLoginManager

#pragma mark - Declare Class as Singleton 
+ (instancetype)loginManager {
    static PCLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Sign Up
- (void)signUpWithFacebook {
    BOOL isSuccess = YES;
    // 페이스북으로 회원가입 시도 후 결과 저장
    [self.delegate didSignUpWithFacebook:isSuccess];
}

- (void)signUpWithEmail {
    PCSignUpResult result = PCSignUpSuccess;
    // 회원가입 폼을 서버에 전송 후 결과 result에 저장
    [self.delegate didSignUpWithEmail:result];
}


#pragma mark - Sign In
- (void)signInWithFacebook {
    BOOL isSuccess = YES;
    // 페이스북으로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithFacebook:isSuccess];
}

- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password {
    BOOL isSuccess = YES;
    // 이메일로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithEmail:isSuccess];
}

- (void)requestNewPassword {
    BOOL isSuccess = YES;
    // 서버에 패스워드 이메일로 전송 요청 후 결과 isSuccess에 저장
    [self.delegate didSendPasswordToEmail:isSuccess];
}

@end
