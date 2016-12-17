//
//  PCTodayRecommendTableViewCell.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 16..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCTodayRecommendTableViewCell.h"

@interface PCTodayRecommendTableViewCell ()

@end

@implementation PCTodayRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Movie Image View
        self.movieImageView = [[UIImageView alloc] init];
        self.movieImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.movieImageView.clipsToBounds = YES;
        [self addSubview:_movieImageView];
        
        // Create Button Menu
        self.menuView = [[UIView alloc] init];
        self.menuView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_menuView];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuView addSubview:_likeButton];
        
        self.ratingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuView addSubview:_ratingButton];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuView addSubview:_commentButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGFloat viewHeight = self.frame.size.height / 6 ;
    CGFloat xOffset = 5;
    CGFloat padding = 2;
    
    self.movieImageView.frame = CGRectMake(0, 0, self.frame.size.width, viewHeight * 5 - (padding * 2));
    self.menuView.frame = CGRectMake(0, viewHeight * 5 - padding, self.frame.size.width, viewHeight);
    self.menuView.layer.borderColor = [UIColor grayColor].CGColor;
    self.menuView.layer.borderWidth = 1;
    
    CGFloat buttonWidth = (self.frame.size.width - 16) / 3;
    self.likeButton.frame = CGRectMake(xOffset, padding, buttonWidth, _menuView.frame.size.height - (padding * 2));
    xOffset += buttonWidth + padding;
    self.ratingButton.frame = CGRectMake(xOffset, padding, buttonWidth, _menuView.frame.size.height - (padding * 2));
    xOffset += buttonWidth + padding;
    self.commentButton.frame = CGRectMake(xOffset, padding, buttonWidth, _menuView.frame.size.height - (padding * 2));
}

- (void)drawRect:(CGRect)rect {
    UIFont *buttonTextFont = [UIFont systemFontOfSize:13.0f];
    
    [self.likeButton setImage:[UIImage imageNamed:@"Rating"] forState:UIControlStateNormal];
    [self.likeButton setTitle:@" 좋아요" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.likeButton.titleLabel.font = buttonTextFont;
    
    [self.ratingButton setImage:[UIImage imageNamed:@"Ranking"] forState:UIControlStateNormal];
    [self.ratingButton setTitle:@" 평가하기" forState:UIControlStateNormal];
    [self.ratingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.ratingButton.titleLabel.font = buttonTextFont;
    
    [self.commentButton setImage:[UIImage imageNamed:@"Recommend"] forState:UIControlStateNormal];
    [self.commentButton setTitle:@" 코멘트" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = buttonTextFont;
}

@end
