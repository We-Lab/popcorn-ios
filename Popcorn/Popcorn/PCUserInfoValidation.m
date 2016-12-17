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
    if ( userID.length > 20 || userID.length < 4 )
        return NO;
    if ([userID rangeOfString:@" "].length > 0)
        return NO;
    
    NSString *filter = @"^[A-Z0-9a-z]{4,20}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userID];
    
    return result;
}

+ (BOOL)isValidPW:(NSString *)userPW {
    if ( userPW.length > 20 || userPW.length < 8 )
        return NO;
    
    NSString *filter = @"^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z0-9]){8,20}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userPW];
    
    return result;
}

+ (BOOL)isValidEmail:(NSString *)email {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:email];
    
    return result;
}

+ (BOOL)isValidNick:(NSString *)userNick {
    if ( userNick.length > 10 || userNick.length < 4 )
        return NO;
    if ([userNick rangeOfString:@" "].length > 0)
        return NO;
    
    NSString *filter = @"^[A-Z0-9a-z]{4,10}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userNick];
    
    return result;
}

+ (BOOL)isValidBirthday:(NSString *)birthday {
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *minDate = [dateFormmater dateFromString:@"1900-01-01"];
    NSDate *inputDate = [dateFormmater dateFromString:birthday];
    NSDate *maxDate = [[NSDate date] dateByAddingTimeInterval:(60*60*9)];
    
    BOOL isLaterThanMinDate = [[minDate earlierDate:inputDate] isEqualToDate:minDate];
    BOOL isEarlierThanMaxDate = [[maxDate laterDate:inputDate] isEqualToDate:maxDate];
    BOOL result = (isLaterThanMinDate && isEarlierThanMaxDate);

    return result;
}

@end
