//
//  RankingDetailTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 9..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCRankingDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@end
