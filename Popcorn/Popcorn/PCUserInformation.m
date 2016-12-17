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

@end

@implementation PCUserInformation

+ (instancetype)userInfo {
    static PCUserInformation *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
    });
    
    return userData;
}

- (void)setUserTokenFromKeyChain {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
    self.userToken = [keychainItem objectForKey:(id)kSecAttrAccount];
}

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

@end
