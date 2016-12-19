//
//  PCUserInformation.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInformation.h"
#import "KeychainItemWrapper.h"

@interface PCUserInformation ()

@property (nonatomic, readwrite) NSString *userToken;
@property (nonatomic) NSDictionary *userInformation;

@property (nonatomic, readwrite, nonnull) NSString *username;
@property (nonatomic, readwrite, nonnull) NSString *nickname;
@property (nonatomic, readwrite, nonnull) NSString *email;
@property (nonatomic, readwrite, nonnull) NSString *gender;
@property (nonatomic, readwrite, nonnull) NSString *birthday;
@property (nonatomic, readwrite, nullable) NSString *phoneNumber;
@property (nonatomic, readwrite, nullable) UIImage *profileImage;
@property (nonatomic, readwrite, nullable) NSDictionary *favoriteTags;


@end

@implementation PCUserInformation

#pragma mark - Init
+ (instancetype)sharedUserData {
    static PCUserInformation *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
    });
    
    return userData;
}

- (void)setUserInformation:(NSDictionary *)userInformation {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
    self.userToken = [keychainItem objectForKey:(id)kSecAttrAccount];
    
    self.username     = userInformation[@"username"];
    self.nickname     = userInformation[@"nickname"];
    self.email        = userInformation[@"email"];
    self.gender       = userInformation[@"gender"];
    self.birthday     = userInformation[@"date_of_birth"];
    self.phoneNumber  = userInformation[@"phone_number"];
    self.profileImage = userInformation[@"profile_img"];
    
    NSDictionary *favoriteTags = @{@"favoriteGenre":userInformation[@"favorite_genre"],
                                   @"favoriteGrade":userInformation[@"favorite_grade"],
                                   @"favoriteCountry":userInformation[@"favorite_making_country"]
                                   };
    self.favoriteTags = favoriteTags;
}


#pragma mark - User Sign In / Sign Out
+ (BOOL)isUserSignedIn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserSignedIn"] boolValue];
}

- (void)hasUserSignedIn:(NSString *)token {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
    [keychainItem setObject:token forKey:(id)kSecAttrAccount];
    self.userToken = token;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserSignedIn"];
}

- (void)hasUserSignedOut {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
    [keychainItem setObject:nil forKey:(id)kSecAttrAccount];
    self.userToken = nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserSignedIn"];
}


#pragma mark - Change User Information
- (void)changeNickname:(NSString *)nickname {
    
}

- (void)changePhoneNumber:(NSString *)nickname {
    
}

- (void)changeFavoriteTag:(NSDictionary *)favoriteTags {
    
}


@end
