//
//  PCRatingViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRatingViewController.h"
#import "PCRatingCustomCell.h"
#import <HCSStarRatingView.h>

@interface PCRatingViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PCRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

#pragma mark - Table View Delegate Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PCRatingCustomCell *ratingCell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell" forIndexPath:indexPath];
    
    if (!ratingCell) {
        
        ratingCell = [[PCRatingCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RatingCell"];
    }
    
    HCSStarRatingView *starRating = [[HCSStarRatingView alloc] init];
    starRating.frame = CGRectMake(0, 0, 150, 35);
    starRating.maximumValue = 5;
    starRating.minimumValue = 0;
    starRating.value = 0;
    starRating.backgroundColor = [UIColor clearColor];
    starRating.allowsHalfStars = YES;
    starRating.accurateHalfStars = YES;
    starRating.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRating.filledStarImage = [UIImage imageNamed:@"FullStar"];
    [ratingCell.ratingMovieStarLayoutView addSubview:starRating];
    
    return ratingCell;
}

- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
