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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.countryLabel = [[UILabel alloc] init];
        self.countryLabel.font = [UIFont systemFontOfSize:14.0f];
        self.countryLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0];
        [self addSubview:_countryLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(12, 8, 46, 44);
    self.textLabel.frame = CGRectMake(66, 8, self.frame.size.width - 66, 25);
    self.countryLabel.frame = CGRectMake(66, 36, self.frame.size.width - 66, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
