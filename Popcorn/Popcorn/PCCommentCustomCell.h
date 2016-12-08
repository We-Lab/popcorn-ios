//
//  PCCommentCustomCell.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 8..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCommentCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentUserImage;
@property (weak, nonatomic) IBOutlet UILabel *commentUserID;
@property (weak, nonatomic) IBOutlet UIView *commentStarRatingView;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *commentLikeText;

@end
