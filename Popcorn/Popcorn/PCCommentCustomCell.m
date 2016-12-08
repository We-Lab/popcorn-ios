//
//  PCCommentCustomCell.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 8..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCCommentCustomCell.h"

@interface PCCommentCustomCell ()

@property (weak, nonatomic) IBOutlet UIView *baseContentView;
@property (weak, nonatomic) IBOutlet UITextView *userContentTextView;

@end

@implementation PCCommentCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
