//
//  PCNetworkParamKey.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 1..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCNetworkParamKey.h"

// 공통
NSString *const memberURLString = @"https://django-api.com/member/";
NSString *const movieURLString = @"https://django-api.com/movie/";
NSString *const mainURLString = @"https://django-api.com/main/";
NSString *const TokenKey = @"key";
NSString *const AuthorizationHeaderKey = @"Authorization";

// Sign In 
NSString *const SignInIDKey = @"username";
NSString *const SignInPasswordKey = @"password";

// Sign Up
NSString *const SignUpIDKey = @"username";
NSString *const SignUpPasswordKey = @"password1";
NSString *const SignUpConfirmPWKey = @"password2";
NSString *const SignUpEmailKey = @"email";
NSString *const SignUpNicknameKey = @"nickname";
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
NSString *const MovieDetailActorKey = @"actor";
NSString *const MovieDetailActorMovieNameKey = @"character_name";
NSString *const MovieDetailPhotosKey = @"image_set";
NSString *const MovieDetailStarAvergeKey = @"star_average";
NSString *const MovieDetailTrailerKey = @"main_trailer";

NSString *const MovieCommentUserIDKey = @"author";
NSString *const MovieCommentUserStarKey = @"star";
NSString *const MovieCommentUserTextKey = @"content";
NSString *const MovieCommentLikeCountKey = @"likes_count";
NSString *const MovieCommentIsLikeKey = @"is_like";
NSString *const MovieCommentWriteDateKey = @"created";

NSString *const MovieFamousLineUserIDKey = @"author";
NSString *const MovieFamousLineActorName = @"actor_kor_name";
NSString *const MovieFamousLineMovieName = @"actor_character_name";
NSString *const MovieFamousLineUserTextKey = @"content";
NSString *const MovieFamousLineLikeCountKey = @"likes_count";
NSString *const MovieFamousLineIsLikeKey = @"is_like";
NSString *const MovieFamousLineWriteDateKey = @"created";















