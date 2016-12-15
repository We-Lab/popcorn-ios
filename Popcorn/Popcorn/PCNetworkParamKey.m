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
NSString *const memberURLString = @"https://django-test.com/member/";
NSString *const movieURLString = @"https://django-test.com/movie/";
NSString *const mainURLString = @"https://django-test.com/main/";
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

// Movie
NSString *const MovieDetailMainImageKey = @"main_image_url";
NSString *const MovieDetailPosterImageKey = @"img_url";
NSString *const MovieDetailTitleKey = @"title_kor";
NSString *const MovieDetailNationKey = @"making_country";
NSString *const MovieDetailGenreKey = @"genre";
NSString *const MovieDetailDateKey = @"created_year";
NSString *const MovieDetailRunningTimeKey = @"run_time";
NSString *const MovieDetailGradeKey = @"grade";
NSString *const MovieDetailStoryKey = @"synopsis";
NSString *const MovieDetailDirecterKey = @"director";
NSString *const MovieDetailActorsKey = @"actors";


