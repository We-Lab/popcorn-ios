//
//  PCLoginNaviView.m
//  Popcorn
//
//  Created by chaving on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCLoginNaviView.h"

@implementation PCLoginNaviView

- (instancetype)initWithType:(LoginNaviBarType)type ViewController:(UIViewController *)vc target:(id)target action:(SEL)action {
    
    self = [super init];
    if (self) {
        if (vc != nil) {
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
            [vc.view addSubview:self];
        }
        [self createNavibarWithType:type target:(id)target action:(SEL)action];
    }
    return self;
}

- (void)createNavibarWithType:(LoginNaviBarType)type target:(id)target action:(SEL)action {
    const NSInteger naviStartPointY = 20 + 5;
    
    CGSize itemSize = CGSizeMake(20, 20);
    
    switch (type) {
        case LoginNaviBarTypeNormal:
            break;
            
        case LoginNaviBarTypePreve: {
            UIButton *preveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, naviStartPointY , itemSize.width, itemSize.height)];
            UIImage *preveImage = [UIImage imageNamed:@"LeftDirection"];
            [preveBtn setImage:preveImage forState:UIControlStateNormal];
            
            [preveBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:preveBtn];
        }
            
        default:
            break;
    }
    
    //right btn
}

@end
