//
//  PCUserInformation.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PCUserProfileUserNameKey;
extern NSString *const PCUserProfileNickNameKey;
extern NSString *const PCUserProfileEmailKey;
extern NSString *const PCUserProfileGenderKey;
extern NSString *const PCUserProfileBirthdayKey;
extern NSString *const PCUserProfilePhoneNumberKey;

@interface PCUserInformation : NSObject

@property (nonatomic, readonly) NSString *userToken;

+ (instancetype)sharedUserData;

#pragma mark - User Sign In / Sign Out
+ (BOOL)isUserSignedIn;
- (void)hasUserSignedIn:(NSString *)token;
- (void)hasUserSignedOut;
- (void)setUserInformationFromServer:(NSDictionary *)userInformation;

// 오토로그인일 때는 미리 저장해둔 데이터로부터 유저정보 세팅
- (void)setUserInformationFromSavedData;


#pragma mark - Get User Information
- (NSString *)getUserInformation:(NSString *)userProfileKey;
- (UIImage *)getUserProfileImage;
- (NSDictionary *)getUserFavoriteTags;


#pragma mark - Change User Information
- (void)changeUserInformation:(NSString *)userProfileKey;
- (void)changeProfileImage:(UIImage *)profileImage;
- (void)changeFavoriteTags:(NSDictionary *)tags;

@end


