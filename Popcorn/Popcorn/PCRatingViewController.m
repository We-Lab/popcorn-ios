//
//  PCRatingViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRatingViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView.h>
#import "PCRatingCustomCell.h"

#import "PCMovieInfoManager.h"
#import "PCUserInfoManager.h"

@interface PCRatingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ratingTableView;

@property (nonatomic) NSString *nextUrlString;
@property (nonatomic) NSString *prevUrlString;
@property (nonatomic) NSArray *movieList;

@property (nonatomic) UILabel *showRatingCountLabel;
@property (nonatomic) NSMutableDictionary *ratingList;

@end

@implementation PCRatingViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestMovieForRating];
    [self createBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}


#pragma mark - Request Movie Data
- (void)requestMovieForRating {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray) {
        if (isSuccess)
            [self didReceiveMovieListForRating:(NSDictionary *)resultArray];
    };
    
    self.ratingList = [NSMutableDictionary new];
    [[PCMovieInfoManager movieManager] requestMovieListForFastRatingWithCompletionHandler:completionHandler];
}

- (void)didReceiveMovieListForRating:(NSDictionary *)receivedData {
    self.nextUrlString = receivedData[@"next"];
    self.prevUrlString = receivedData[@"previous"];
    self.movieList = receivedData[@"results"];
    
    [_ratingTableView reloadData];
}

#pragma mark - BarButtonItem
- (void)createBarButtonItem {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 50, 50);
    [barButton setTitle:@"적용" forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [barButton addTarget:self action:@selector(saveRatingData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 8, 20, 20)];
    badgeView.layer.cornerRadius = 11;
    badgeView.backgroundColor = [UIColor colorWithRed:0.94 green:0.33 blue:0.41 alpha:1.0];
    [barButton addSubview:badgeView];
    
    self.showRatingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 11, 11)];
    self.showRatingCountLabel.textColor = [UIColor whiteColor];
    self.showRatingCountLabel.text = @"0";
    self.showRatingCountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.showRatingCountLabel.textAlignment = NSTextAlignmentCenter;
    [badgeView addSubview:_showRatingCountLabel];
    
    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
}

- (void)saveRatingData:(id)data {
    for (NSNumber *ratingMovieTag in _ratingList.allKeys) {
        NSString *movieID = _movieList[[ratingMovieTag integerValue]][@"id"];
        CGFloat ratingValue = [_ratingList[ratingMovieTag] floatValue];
        [[PCUserInfoManager userInfoManager] saveMovieRating:ratingValue
                                                 withMovieID:movieID
                                        andCompletionHandler:^(BOOL isSuccess) {
                                        }];
    }
    
    [self requestMovieForRating];
}


#pragma mark - Table View Delegate Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieList.count;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PCRatingCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movieData = _movieList[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:movieData[@"img_url"]];
    [cell.movieImageView sd_setImageWithURL:imageURL
                           placeholderImage:[UIImage imageNamed:@"MoviePlaceholder"]
                                    options:SDWebImageRetryFailed | SDWebImageCacheMemoryOnly];
    
    cell.ratingMovieTitle.text = movieData[@"title_kor"];
    NSString *infoString = [NSString stringWithFormat:@"%@", movieData[@"created_year"]];
    cell.ratingMovieInfo.text = infoString;
    
    HCSStarRatingView *starRating = [[HCSStarRatingView alloc] init];
    starRating.frame = CGRectMake(0, 0, 150, 35);
    starRating.maximumValue = 5;
    starRating.minimumValue = 0;
    starRating.value = 0;
    starRating.backgroundColor = [UIColor clearColor];
    starRating.allowsHalfStars = YES;
    starRating.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRating.filledStarImage = [UIImage imageNamed:@"FullStar"];
    starRating.tag = indexPath.row;
    [starRating addTarget:self action:@selector(observeRatingValue:) forControlEvents:UIControlEventValueChanged];
    [cell.ratingMovieStarLayoutView addSubview:starRating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCRatingCustomCell *ratingCell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell" forIndexPath:indexPath];
    
//    NSDictionary *movieData = _movieList[indexPath.row];
//    
//    NSURL *imageURL = [NSURL URLWithString:movieData[@"img_url"]];
//    [ratingCell.movieImageView sd_setImageWithURL:imageURL
//                                 placeholderImage:[UIImage imageNamed:@"MoviePlaceholder"]
//                                          options:SDWebImageRetryFailed | SDWebImageCacheMemoryOnly];
//    
//    ratingCell.ratingMovieTitle.text = movieData[@"title_kor"];
//    NSString *infoString = [NSString stringWithFormat:@"%@", movieData[@"created_year"]];
//    ratingCell.ratingMovieInfo.text = infoString;
//    
//    HCSStarRatingView *starRating = [[HCSStarRatingView alloc] init];
//    starRating.frame = CGRectMake(0, 0, 150, 35);
//    starRating.maximumValue = 5;
//    starRating.minimumValue = 0;
//    starRating.value = 0;
//    starRating.backgroundColor = [UIColor clearColor];
//    starRating.allowsHalfStars = YES;
//    starRating.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
//    starRating.filledStarImage = [UIImage imageNamed:@"FullStar"];
//    starRating.tag = indexPath.row;
//    [starRating addTarget:self action:@selector(observeRatingValue:) forControlEvents:UIControlEventValueChanged];
//    [ratingCell.ratingMovieStarLayoutView addSubview:starRating];
    
    return ratingCell;
}

- (void)observeRatingValue:(HCSStarRatingView *)sender {
    NSNumber *keyValue = [NSNumber numberWithUnsignedInteger:sender.tag];
    
    if (sender.value != 0) {
        _ratingList[keyValue] = [NSNumber numberWithFloat:sender.value];
    }
    else {
        if ([_ratingList objectForKey:keyValue] != nil) {
            [_ratingList removeObjectForKey:keyValue];
        }
    }
    
    self.showRatingCountLabel.text = [NSString stringWithFormat:@"%lu", [_ratingList count]];
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
