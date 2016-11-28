//
//  PCUserInfoValidation.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCUserInfoValidation : NSObject

+ (BOOL)isValidID:(NSString *)userID;
+ (BOOL)isValidPW:(NSString *)userPW;
+ (BOOL)isValidEmail:(NSString *)emailString;
+ (BOOL)isValidBirthday;

@end
