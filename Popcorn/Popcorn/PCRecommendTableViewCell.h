//
//  PCRecommendTableViewCell.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCMovieInformationView.h"
#import "PCUserInteractionMenuView.h"

@interface PCRecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PCMovieInformationView *movieView;
@property (weak, nonatomic) IBOutlet PCUserInteractionMenuView *menuView;

@end
