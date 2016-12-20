//
//  PCUserInteractionManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UserInfoTaskHandler) (void);

@interface PCUserInfoManager : NSObject

+ (instancetype)userInfoManager;

// 유저 프로필
- (void)changeUserProfile:(NSString *)userProfileKey withCompletionHandler:(UserInfoTaskHandler)completionHandler;
- (void)changeUserFavoriteTags:(NSDictionary *)tags withCompletionHandler:(UserInfoTaskHandler)completionHandler;


// 영화 관련 
- (void)saveMovieRating:(NSString *)movieID;


@end
