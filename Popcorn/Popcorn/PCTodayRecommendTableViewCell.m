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
        
        // Movie Info On Movie Image View
        self.averageRatingLabel = [[UILabel alloc] init];
        self.movieTitleLabel = [[UILabel alloc] init];
        [self.movieImageView addSubview:_averageRatingLabel];
        [self.movieImageView addSubview:_movieTitleLabel];
        
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
    CGFloat viewHeight = [self ratioHeight:self.frame.size.height / 6];
    CGFloat xOffset = [self ratioWidth:5];
    CGFloat menuPadding = 2;
    CGFloat cellWidthSize = [self ratioWidth:self.frame.size.width];
    
    self.movieImageView.frame = CGRectMake(0, 0, cellWidthSize, viewHeight * 5 - (menuPadding * 2));
    self.menuView.frame = CGRectMake(0, viewHeight * 5 - menuPadding, cellWidthSize, viewHeight);
    self.menuView.layer.borderColor = [UIColor grayColor].CGColor;
    self.menuView.layer.borderWidth = 1;
    
    CGFloat buttonWidth = [self ratioWidth:(self.frame.size.width - 16) / 3];
    self.likeButton.frame = CGRectMake(xOffset, menuPadding, buttonWidth, _menuView.frame.size.height - (menuPadding * 2));
    xOffset += buttonWidth + menuPadding;
    self.ratingButton.frame = CGRectMake(xOffset, menuPadding, buttonWidth, _menuView.frame.size.height - (menuPadding * 2));
    xOffset += buttonWidth + menuPadding;
    self.commentButton.frame = CGRectMake(xOffset, menuPadding, buttonWidth, _menuView.frame.size.height - (menuPadding * 2));
    
    CGFloat labelPadding = 5;
    CGSize imageViewSize = _movieImageView.bounds.size;
    CGFloat movieInfoLabelHeight = [self ratioHeight:25];
    
    self.averageRatingLabel.frame = CGRectMake(labelPadding, imageViewSize.height - (movieInfoLabelHeight * 2) - labelPadding, _movieImageView.bounds.size.width, movieInfoLabelHeight);
    self.movieTitleLabel.frame = CGRectMake(labelPadding, imageViewSize.height - (movieInfoLabelHeight + labelPadding), _movieImageView.bounds.size.width, movieInfoLabelHeight);
}

- (void)drawRect:(CGRect)rect {
    self.averageRatingLabel.textColor = [UIColor whiteColor];
    self.movieTitleLabel.textColor = [UIColor whiteColor];
    
    
    [self.likeButton setTitle:@" 좋아요" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.likeButton.titleLabel.font = buttonTextFont;
    
    
    [self.ratingButton setTitle:@" 평가하기" forState:UIControlStateNormal];
    [self.ratingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.ratingButton.titleLabel.font = buttonTextFont;
    
    [self.commentButton setTitle:@" 코멘트" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.commentButton.titleLabel.font = buttonTextFont;
}

- (CGFloat)ratioWidth:(CGFloat)width {
    return (width * [UIScreen mainScreen].bounds.size.width) / 375;
}

- (CGFloat)ratioHeight:(CGFloat)height {
    return (height * [UIScreen mainScreen].bounds.size.height) / 667;
}

@end
