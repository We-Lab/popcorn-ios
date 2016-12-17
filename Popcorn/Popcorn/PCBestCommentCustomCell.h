//
//  PCBestCommentCustomCell.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 16..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCBestCommentCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bestCommentUserID;
@property (weak, nonatomic) IBOutlet UIView *bestCommentStarScoreView;
@property (weak, nonatomic) IBOutlet UILabel *bestCommentText;
@property (weak, nonatomic) IBOutlet UILabel *bestCommentLikeText;
@property (weak, nonatomic) IBOutlet UILabel *bestCommentWriteDate;

@end
