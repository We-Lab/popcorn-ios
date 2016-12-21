//
//  PCMyPageFamousTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMyPageFamousTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myFamousActorImage;
@property (weak, nonatomic) IBOutlet UILabel *myFamousMovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *myFamousActorName;
@property (weak, nonatomic) IBOutlet UILabel *myFamousText;
@property (weak, nonatomic) IBOutlet UILabel *myFamousLikeText;
@property (weak, nonatomic) IBOutlet UILabel *myFamousDate;

@end
