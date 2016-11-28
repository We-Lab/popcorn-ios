//
//  PCUserInformation.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInformation.h"

@implementation PCUserInformation

+ (instancetype)userInfo {
    static PCUserInformation *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
    });
    
    return userData;
}


+ (BOOL)isUserSignedIn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserSignedIn"] boolValue];
}

+ (void)hasUserSignedIn {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserSignedIn"];
}

+ (void)hasUserSignedOut {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserSignedIn"];
}

@end
