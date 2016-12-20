//
//  BoxOfficeCustomView.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "BoxOfficeCustomView.h"

@implementation BoxOfficeCustomView

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustom {
    
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    
    if (self) {
        
        
    }
    return self;
}


//-(id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        if (self.subviews.count == 0) {
//            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
//            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            subview.frame = self.bounds;
//            [self addSubview:subview];
//        }
//    }
//    return self;
//}


//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"BoxOfficeCustomView"
//                                                         owner:self
//                                                       options:nil] objectAtIndex:0];
//        xibView.frame = self.bounds;
//        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self addSubview: xibView];
//    }
//    return self;
//}



@end
