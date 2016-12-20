//
//  PCUserInformation.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInformation.h"

#import "KeychainItemWrapper.h"
#import "PCUserInfoManager.h"

@interface PCUserInformation ()

@property (nonatomic) KeychainItemWrapper *keychainItem;
@property (nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic, readwrite) NSString *userToken;
@property (nonatomic, readwrite) NSMutableDictionary *userInformation;

@end

static NSString *const PCUserInformationAsDictionaryKey = @"UserInformationAsDictionary";

//Extern String
NSString *const PCUserProfileUserNameKey = @"username";
NSString *const PCUserProfileNickNameKey = @"nickname";
NSString *const PCUserProfileEmailKey = @"email";
NSString *const PCUserProfileGenderKey = @"gender";
NSString *const PCUserProfileBirthdayKey = @"date_of_birth";
NSString *const PCUserProfilePhoneNumberKey = @"phone_number";
NSString *const PCUserProfileFavoriteGenreKey = @"favorite_genre";
NSString *const PCUserProfileFavoriteGradeKey = @"favorite_grade";
NSString *const PCUserProfileFavoriteCountryKey = @"favorite_making_country";


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

- (instancetype)init {
    self = [super init];
    if (self) {
        _keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)setUserInformationFromSavedData {
    self.userToken = [_keychainItem objectForKey:(id)kSecAttrAccount];
    self.userInformation = [[_userDefaults objectForKey:PCUserInformationAsDictionaryKey] mutableCopy];
}



#pragma mark - User Sign In / Sign Out
+ (BOOL)isUserSignedIn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserSignedIn"] boolValue];
}

- (void)hasUserSignedIn:(NSString *)token {
    NSString *tokenValue = [NSString stringWithFormat:@"Token %@", token];
    
    [_userDefaults setBool:YES forKey:@"UserSignedIn"];
    [self.keychainItem setObject:tokenValue forKey:(id)kSecAttrAccount];
    self.userToken = tokenValue;
}

- (void)setUserInformationFromServer:(NSDictionary *)userInformation {
    
    // URL에서 profile 이미지를 받아 파일로 저장
    NSString *urlString = userInformation[@"profile_img"];
    NSString *imagePath = nil;
    if (urlString != nil || urlString.length != 0) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        imagePath = [self documentsPathForFileName:@"ProfileImage.jpg"];
        [imageData writeToFile:imagePath atomically:YES];
    }
    
    self.userInformation = [userInformation mutableCopy];
    [_userDefaults setObject:userInformation forKey:PCUserInformationAsDictionaryKey];
}

- (void)hasUserSignedOut {
    [self.keychainItem setObject:nil forKey:(id)kSecAttrAccount];
    [_userDefaults setBool:NO forKey:@"UserSignedIn"];
    [_userDefaults setObject:nil forKey:PCUserInformationAsDictionaryKey];
    self.userToken = nil;
    self.userInformation = nil;
    
    // 저장된 프로필 이미지 삭제
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath = [self documentsPathForFileName:@"ProfileImage.jpg"];
    if (imagePath)
        [fileManager removeItemAtPath:imagePath error:NULL];
}


- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


- (NSString *)getUserInformation:(NSString *)userProfileKey {
    return _userInformation[userProfileKey];
}

- (UIImage *)getUserProfileImage {
    UIImage *image = [UIImage imageNamed:@"Profile_placeholder"];
    
    NSString *imagePath = [_userDefaults objectForKey:@"ProfileImagePath"];
    if (imagePath)
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    
    return image;
}

- (NSDictionary *)getUserFavoriteTags {
    NSDictionary *tags = @{@"genre":_userInformation[@"favorite_genre"],
                           @"grade":_userInformation[@"favorite_grade"],
                           @"country":_userInformation[@"favorite_making_country"],
                           };
    return tags;
}

#pragma mark - Change User Information
- (void)changeUserProfile:(NSString *)userProfileKey withString:(NSString *)newString{
//    self.userInformation setObject:newString forKey:<#(nonnull id<NSCopying>)#>
//    [PCUserInfoManager userInfoManager] changeUserProfile:<#(NSString *)#> withCompletionHandler:<#^(void)completionHandler#>
}

- (void)changeProfileImage:(UIImage *)profileImage {
    NSData *imageData = UIImageJPEGRepresentation(profileImage, 1.0);
    NSString *imagePath = [self documentsPathForFileName:@"ProfileImage.jpg"];
    [imageData writeToFile:imagePath atomically:YES];
    
//    [[PCUserInfoManager userInfoManager] requestChangeProfileImageWithData:imageData withToken
}

- (void)changeFavoriteTags:(NSDictionary *)tags {
    
    
}


@end
