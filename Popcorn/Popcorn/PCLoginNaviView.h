//
//  PCLoginNaviView.h
//  Popcorn
//
//  Created by chaving on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    LoginNaviBarTypeNormal = 0,
    LoginNaviBarTypePreve = 1
    
}LoginNaviBarType;

@interface PCLoginNaviView : UIView

- (instancetype)initWithType:(LoginNaviBarType)type ViewController:(UIViewController *)vc target:(id)target action:(SEL)action;

@end
