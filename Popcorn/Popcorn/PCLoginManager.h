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

// 회원가입
- (void)signUpWithFacebook;
- (void)signUpWithID:(NSDictionary *)form;


// 로그인
- (void)signInWithFacebook;
- (void)signInWithID:(NSString *)loginID andPassword:(NSString *)password;
- (void)requestNewPassword;

@end

