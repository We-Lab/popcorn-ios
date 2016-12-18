//
//  PCUserInfoManager.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInfoManager.h"

@implementation PCUserInfoManager

+ (instancetype)userManager {
    static PCUserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PCUserInfoManager alloc] init];
    });
    
    return manager;
}



@end
