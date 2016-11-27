//
//  PCLoginManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCLoginManagerDelegate.h"

@interface PCLoginManager : NSObject

@property (nonatomic, weak) id<PCLoginManagerDelegate> delegate;

+ (instancetype)loginManager;

// 회원가입
- (void)signUpWithFacebook;
- (void)signUpWithEmail;
// 선호장르는 회원가입 시키고 업데이트 형태로??? 아니면 회원가입 폼에 추가해서 한번에 추가하는 형태???


// 로그인
- (void)signInWithFacebook;
- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)requestNewPassword;

@end
