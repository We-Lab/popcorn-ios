//
//  PCMyPageLikeTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMyPageLikeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myLikeMoviePoster;
@property (weak, nonatomic) IBOutlet UILabel *myLikeMovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *myLikeMovieInfo;
@property (weak, nonatomic) IBOutlet UILabel *myLikeMovieGrade;
@property (weak, nonatomic) IBOutlet UIView *myLikeMovieStarView;

@end
