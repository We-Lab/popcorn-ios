//
//  BoxOfficeCustomView.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxOfficeCustomView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *boxOfficePoster;
@property (strong, nonatomic) IBOutlet UILabel *boxOfficeMovieTitle;


- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithCustom;

@end
