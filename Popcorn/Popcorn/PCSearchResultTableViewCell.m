//
//  PCSearchResultTableViewCell.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 8..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSearchResultTableViewCell.h"

@interface PCSearchResultTableViewCell ()
@end

@implementation PCSearchResultTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.additionalInfoLabel = [[UILabel alloc] init];
        self.additionalInfoLabel.font = [UIFont systemFontOfSize:14.0f];
        self.additionalInfoLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0];
        [self addSubview:_additionalInfoLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(12, 8, 46, 44);
    self.textLabel.frame = CGRectMake(66, 8, self.frame.size.width - 66, 25);
    self.additionalInfoLabel.frame = CGRectMake(66, 36, self.frame.size.width - 66, 15);
}

@end
