//
//  PCRatingCustomCell.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 13..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCRatingCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieInfo;
@property (weak, nonatomic) IBOutlet UIView *ratingMovieStarLayoutView;

@end
