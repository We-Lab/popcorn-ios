//
//  PCUserInfoValidation.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInfoValidation.h"

@implementation PCUserInfoValidation

#pragma mark - Validate UserInfo
+ (BOOL)isValidID:(NSString *)userID {
    if ( userID.length > 10 || userID.length < 4 )
        return NO;
    if ([userID rangeOfString:@" "].length > 0)
        return NO;
    
    NSString *filter = @"^[A-Z0-9a-z]{4,10}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userID];
    
    return result;
}

+ (BOOL)isValidPW:(NSString *)userPW {
    if ( userPW.length > 15 || userPW.length < 6 )
        return NO;
    
    NSString *filter = @"^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z0-9]){6,20}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userPW];
    
    return result;
}

+ (BOOL)isValidEmail:(NSString *)emailString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

+ (BOOL)isValidBirthday {
    BOOL isValid = YES;
    
    //1900년 이상 현재 날짜 이하
    return isValid;
}

@end
