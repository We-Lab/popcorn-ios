//
//  PCChangeInfoTextViewController.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ChangeInfoType) {
    ChangePassword,
    ChangePhoneNumber,
    ChangeNickname,
};

@interface PCChangeInfoTextViewController : UIViewController

@property ChangeInfoType type;

@end
