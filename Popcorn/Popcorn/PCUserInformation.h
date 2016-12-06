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

+ (instancetype)userInfo;

#pragma mark - User Data
- (void)setUserTokenFromKeyChain;
- (void)saveUserToken:(NSString *)token;

#pragma mark - User Sign In Information
+ (BOOL)isUserSignedIn;
+ (void)hasUserSignedIn;
+ (void)hasUserSignedOut;

@end
