//
//  PCBoxOfficeData.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 15..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCBoxOfficeData.h"

@implementation PCBoxOfficeData

+ (instancetype)sharedBoxOffice {
    static PCBoxOfficeData *boxoffice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        boxoffice = [[PCBoxOfficeData alloc] init];
    });
    return boxoffice;
}

@end
