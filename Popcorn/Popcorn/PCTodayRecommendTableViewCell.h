//
//  PCTodayRecommendTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 16..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTodayRecommendTableViewCell : UITableViewCell

@property (nonatomic) UIImageView *movieImageView;
@property (nonatomic) UILabel *averageRatingLabel;
@property (nonatomic) UILabel *movieTitleLabel;

@property (nonatomic) UIView *menuView;
@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UIButton *ratingButton;
@property (nonatomic) UIButton *commentButton;

@end
