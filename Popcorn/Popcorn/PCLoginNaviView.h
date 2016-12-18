//
//  PCLoginNaviView.h
//  Popcorn
//
//  Created by chaving on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginNaviBarType) {
    LoginNaviBarTypeNormal = 0,
    LoginNaviBarTypePreve = 1
};

@interface PCLoginNaviView : UIView

@property (nonatomic) UIButton *prevButton;

- (instancetype)initWithType:(LoginNaviBarType)type andViewController:(UIViewController *)viewController;

@end
