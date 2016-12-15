//
//  PCBoxOfficeData.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 15..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCBoxOfficeData : NSObject

+ (instancetype)sharedBoxOffice;

@property (nonatomic) NSArray *boxOfficeList;

@end
