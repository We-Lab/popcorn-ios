//
//  PCMyPageCommentTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMyPageCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myCommentTitle;
@property (weak, nonatomic) IBOutlet UIView *myCommentStarScoreView;
@property (weak, nonatomic) IBOutlet UILabel *myCommentText;
@property (weak, nonatomic) IBOutlet UILabel *myCommentLikeText;
@property (weak, nonatomic) IBOutlet UILabel *myCommentDate;

@end
