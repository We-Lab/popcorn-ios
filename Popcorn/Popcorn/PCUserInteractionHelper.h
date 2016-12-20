//
//  PCUserInteractionHelper.h
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCUserInteractionHelper : NSObject

@property (nonatomic) NSString *movieID;

+ (instancetype)helperManager;

- (void)changeLikeStateWithMovieID:(NSString *)movieID;
- (void)showRatingMovieViewWithMovieID:(NSString *)movieID;
- (void)showCommentViewWithMovieID:(NSString *)movieID;


@end
