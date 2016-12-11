//
//  PCRecommendTagButton.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 10..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRecommendTagButton.h"

@implementation PCRecommendTagButton

- (void)configureButtonWithTitle:(NSString *)title {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.layer.cornerRadius = 15.0f;
    self.layer.borderWidth = 1;
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
}

- (void)drawRect:(CGRect)rect {
    if ([self isSelected] || [self isHighlighted]) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    else {
        self.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8].CGColor;
    }
}

@end
