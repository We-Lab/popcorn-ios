//
//  PCUserInformation.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PCUserInformation : NSObject

@property (nonatomic, readonly) NSString *userToken;
@property (nonatomic, readonly) NSMutableDictionary *userInformation;

+ (instancetype)sharedUserData;

#pragma mark - User Sign In / Sign Out
+ (BOOL)isUserSignedIn;
- (void)hasUserSignedIn:(NSString *)token;
- (void)hasUserSignedOut;

// 일반로그인 : 서버에서 정보 불러와서 세팅, 자동로그인 : 저장해둔 데이터로부터 유저정보 세팅
- (void)setUserInformationFromServer:(NSDictionary *)userInformation;
- (void)setUserInformationFromSavedData;


#pragma mark - Get User Information
- (NSString *)getUserInformation:(NSString *)userProfileKey;
- (UIImage *)getUserProfileImage;
- (NSDictionary *)getUserFavoriteTags;


#pragma mark - Change User Information
- (void)changeUserProfile:(NSString *)userProfileKey withString:(NSString *)newString;
- (void)changeProfileImage:(UIImage *)profileImage;
- (void)changeFavoriteTags:(NSDictionary *)tags;

@end


