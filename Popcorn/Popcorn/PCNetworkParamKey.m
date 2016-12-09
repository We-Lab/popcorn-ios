//
//  PCNetworkParamKey.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 1..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCNetworkParamKey.h"

@implementation PCNetworkParamKey

@end

// 공통
NSString *const memberURLString = @"http://popcorn-backend2-dev.ap-northeast-2.elasticbeanstalk.com/member/";
NSString *const movieURLString = @"http://popcorn-backend2-dev.ap-northeast-2.elasticbeanstalk.com/movie/";
NSString *const mainURLString = @"http://popcorn-backend2-dev.ap-northeast-2.elasticbeanstalk.com/main/";
NSString *const TokenKey = @"key";

// SignIn
NSString *const SignInIDKey = @"username";
NSString *const SignInPasswordKey = @"password";

// SignUp
NSString *const SignUpIDKey = @"username";
NSString *const SignUpPasswordKey = @"password1";
NSString *const SignUpConfirmPWKey = @"password2";
NSString *const SignUpEmailKey = @"email";
NSString *const SignUpBirthdayKey = @"date_of_birth";
NSString *const SignUpGenderKey = @"gender";
NSString *const SignUpPhoneNumberKey = @"phone_number";

