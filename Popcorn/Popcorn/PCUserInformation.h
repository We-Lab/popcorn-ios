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

// 유저 정보
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *nickname;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *gender;
@property (nonatomic, readonly) NSString *birthday;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) UIImage *profileImage;
@property (nonatomic, readonly) NSDictionary *favoriteTags;


#pragma mark - Init 
+ (instancetype)sharedUserData;
- (void)setUserInformation:(NSDictionary *)userInformation;


#pragma mark - User Sign In / Sign Out
+ (BOOL)isUserSignedIn;
- (void)hasUserSignedIn:(NSString *)token;
- (void)hasUserSignedOut;


#pragma mark - Change User Information
- (void)changeNickname:(NSString *)nickname;
- (void)changePhoneNumber:(NSString *)nickname;
- (void)changeFavoriteTag:(NSDictionary *)favoriteTags;

@end
