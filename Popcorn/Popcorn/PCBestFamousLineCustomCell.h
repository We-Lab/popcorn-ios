//
//  PCBestFamousLineCustomCell.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 16..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCBestFamousLineCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bestFamousLineUserID;
@property (weak, nonatomic) IBOutlet UILabel *bestFamousLineMovieName;
@property (weak, nonatomic) IBOutlet UILabel *bestFamousLineText;
@property (weak, nonatomic) IBOutlet UILabel *bestFamousLineLikeText;
@property (weak, nonatomic) IBOutlet UILabel *bestFamousLineWriteDate;
@property (weak, nonatomic) IBOutlet UIImageView *bestFamousLineActorImage;

@end
