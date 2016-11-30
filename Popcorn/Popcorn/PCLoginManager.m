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

- (void)dealloc {
    dLog(@" ");
}

#pragma mark - Sign Up
- (void)signUpWithFacebook {
    BOOL isSuccess = YES;
    // 페이스북으로 회원가입 시도 후 결과 저장
    [self.delegate didSignUpWithFacebook:isSuccess];
}

- (void)signUpWithID {
    PCSignUpResult result = PCSignUpSuccess;
    // 회원가입 폼을 서버에 전송 후 결과 result에 저장
    [self.delegate didSignUpWithID:result];
}

- (void)updatePreferenceGenre {
}


#pragma mark - Sign In
- (void)signInWithFacebook {
    BOOL isSuccess = YES;
    // 페이스북으로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithFacebook:isSuccess];
}

- (void)signInWithID:(NSString *)loginID andPassword:(NSString *)password {
    NSString *token = nil;
    // 이메일로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithID:token];
}

- (void)requestNewPassword {
    BOOL isSuccess = YES;
    // 서버에 패스워드 이메일로 전송 요청 후 결과 isSuccess에 저장
    [self.delegate didSendPasswordToID:isSuccess];
}

@end
