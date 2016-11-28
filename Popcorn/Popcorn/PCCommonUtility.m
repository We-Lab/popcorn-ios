//
//  PCUtility.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCCommonUtility.h"

@implementation PCCommonUtility

+ (UIAlertController *)alertControllerWithOnlyTitle:(NSString *)title {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"확인"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertControl addAction:confirmAction];
    [alertControl addAction:cancelAction];
    return alertControl;
}

@end
