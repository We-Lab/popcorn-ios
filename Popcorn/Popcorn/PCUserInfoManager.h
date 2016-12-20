//
//  PCUserInteractionManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UserInfoTaskHandler) (BOOL isSuccess);

@interface PCUserInfoManager : NSObject

+ (instancetype)userInfoManager;

// 유저 프로필
- (void)changeUserProfile:(NSString *)userProfileKey withNewData:(NSString *)newData andCompletionHandler:(UserInfoTaskHandler)completionHandler;
- (void)changeUserProfileImage:(UIImage *)profileImage withCompletionHandler:(UserInfoTaskHandler)completionHandler;
- (void)changeUserFavoriteTags:(NSDictionary *)tags withCompletionHandler:(UserInfoTaskHandler)completionHandler;
- (void)deleteAllFavoriteTagsWithCompletionHandler:(UserInfoTaskHandler)completionHandler;


// 영화 관련 
- (void)saveMovieRating:(NSString *)movieID;


@end
