//
//  PCNetworkParamKey.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 1..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCNetworkParamKey : NSObject

@end

// 공통
extern NSString *const memberURLString;
extern NSString *const movieURLString;
extern NSString *const TokenKey;

// Sign In
extern NSString *const SignInIDKey;
extern NSString *const SignInPasswordKey;

// Sign Up
extern NSString *const SignUpIDKey;
extern NSString *const SignUpPasswordKey;
extern NSString *const SignUpConfirmPWKey;
extern NSString *const SignUpEmailKey;
extern NSString *const SignUpBirthdayKey;
extern NSString *const SignUpGenderKey;
extern NSString *const SignUpPhoneNumberKey;
