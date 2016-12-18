//
//  PCFamousLineCustomCell.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 11..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFamousLineCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *famousLineUserID;
@property (weak, nonatomic) IBOutlet UILabel *famousLineMovieName;
@property (weak, nonatomic) IBOutlet UILabel *famousLineText;
@property (weak, nonatomic) IBOutlet UILabel *famousLineLikeText;
@property (weak, nonatomic) IBOutlet UILabel *famousLineWriteDate;

@end
