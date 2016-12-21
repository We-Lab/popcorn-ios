//
//  PCSearchResultTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 8..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSearchResultTableViewCell : UITableViewCell
@property (nonatomic) UILabel *additionalInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *searchMoviePoster;
@property (weak, nonatomic) IBOutlet UILabel *searchMovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchMovieScore;
@property (weak, nonatomic) IBOutlet UILabel *searchMovieInfo;
@end
