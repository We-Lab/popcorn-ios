//
//  PCBestCommentCustomCell.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 16..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCBestCommentCustomCell.h"
#import <HCSStarRatingView.h>

@implementation PCBestCommentCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(0, 0, 120, self.bestCommentStarScoreView.frame.size.height);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 3.5;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
    starRatingView.userInteractionEnabled = NO;
    [self.bestCommentStarScoreView addSubview:starRatingView];
    
    self.bestCommentText.text = @"으아니이";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
