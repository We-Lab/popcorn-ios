//
//  PCLoginNaviView.m
//  Popcorn
//
//  Created by chaving on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCLoginNaviView.h"

@implementation PCLoginNaviView

- (instancetype)initWithType:(LoginNaviBarType)type andViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        [viewController.view addSubview:self];
        [self createNavibarWithType:type];
    }
    return self;
}

- (void)createNavibarWithType:(LoginNaviBarType)type {
    const NSInteger naviStartPointY = 20 + 5;
    CGSize itemSize = CGSizeMake(20, 20);
    
    switch (type) {
        case LoginNaviBarTypeNormal:
            break;
            
        case LoginNaviBarTypePreve: {
            _prevButton = [[UIButton alloc]initWithFrame:CGRectMake(10, naviStartPointY , itemSize.width, itemSize.height)];
            UIImage *preveImage = [UIImage imageNamed:@"LeftDirection"];
            [_prevButton setImage:preveImage forState:UIControlStateNormal];
            
            [self addSubview:_prevButton];
        }
    }
}

@end
