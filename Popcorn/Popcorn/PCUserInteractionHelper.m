//
//  PCUserInteractionHelper.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInteractionHelper.h"

#import <HCSStarRatingView.h>
#import "PCUserInteractionManager.h"
#import "PCCommentWriteViewController.h"

@implementation PCUserInteractionHelper

+ (instancetype)helperManager {
    static PCUserInteractionHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PCUserInteractionHelper alloc] init];
    });
    
    return manager;
}

- (void)changeLikeStateWithMovieID:(NSString *)movieID {
//    sLog(movieID);
}

- (void)showRatingMovieViewWithMovieID:(NSString *)movieID {
    self.movieID = movieID;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"영화를 평가해주세요.\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIView *starRatingView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 250, 50)];
    [starRatingView setBackgroundColor:[UIColor clearColor]];
    [alertController.view addSubview:starRatingView];
    
    HCSStarRatingView *starRating = [[HCSStarRatingView alloc] init];
    starRating.frame = CGRectMake(25, 10, 200, 30);
    starRating.maximumValue = 5;
    starRating.minimumValue = 0;
    starRating.value = 0;
    starRating.backgroundColor = [UIColor clearColor];
    starRating.allowsHalfStars = YES;
    starRating.accurateHalfStars = YES;
    starRating.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRating.filledStarImage = [UIImage imageNamed:@"FullStar"];
    [starRatingView addSubview:starRating];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PCUserInteractionManager saveMovieRating:_movieID];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *currentVC = [window rootViewController];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

- (void)showCommentViewWithMovieID:(NSString *)movieID {
    UITabBarController *mainTabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *currentNVC = mainTabBar.selectedViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieInfo" bundle:nil];
    PCCommentWriteViewController *commentWriteVC = [storyboard instantiateViewControllerWithIdentifier:@"CommentWriteStoryboard"];
    commentWriteVC.movieID = movieID;
    [currentNVC pushViewController:commentWriteVC animated:YES];
}

@end
