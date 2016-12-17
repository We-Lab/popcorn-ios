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
    [alertControl addAction:confirmAction];
    return alertControl;
}

+ (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize andAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height) blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)makeTextShadow:(UILabel *)label opacity:(CGFloat)opacity{

    label.layer.masksToBounds = NO;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowRadius = 2;
    label.layer.shadowOpacity = opacity;
}

@end
