//
//  UserInteractionMenu.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInteractionMenuView.h"
#import "PCUserInteractionHelper.h"

@implementation PCUserInteractionMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"PCUserInteractionMenuView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
        
        [self.likeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickButton:(UIButton *)button {
    button.selected = !button.selected;
}

@end
