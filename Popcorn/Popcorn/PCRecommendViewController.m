//
//  PCRecommendViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRecommendViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "PCMovieInfoManager.h"
#import "PCRecommendTableViewCell.h"
#import "PCUserInteractionHelper.h"
#import "PCMovieDetailDataCenter.h"

@interface PCRecommendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UIButton *toTagViewButton;

@property (nonatomic) UIView *refreshColorView;
@property (nonatomic) UIView *refreshLoadingView;
@property (nonatomic) UIImageView *loadingImg;
@property (nonatomic) BOOL isRefreshAnimating;

@property (nonatomic) NSArray *recommendMovieList;

@end

@implementation PCRecommendViewController {
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_toTagViewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self initCustomRefreshControl];
    [self requestRecommendMovieList];
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
- (void)requestRecommendMovieList {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray) {
        if (isSuccess) {
            [self didReceiveFavoriteMovieRecommend:resultArray];
        }
        else {
            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
        }
    };
    [[PCMovieInfoManager movieManager] requestMovieByUserFavoriteWithCompletionHandler:completionHandler];
}

- (void)didReceiveFavoriteMovieRecommend:(NSArray *)recommendList {
    _recommendMovieList = recommendList;
    [self.recommendTableView reloadData];
}

#pragma mark - Configure TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendMovieList.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PCRecommendTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movieData = _recommendMovieList[indexPath.row];
    
    [cell.movieView.movieImageView sd_setImageWithURL:movieData[@"main_image_url"]
                                     placeholderImage:[UIImage imageNamed:@"MoviePlaceholderExtented"]
                                              options:SDWebImageCacheMemoryOnly | SDWebImageRetryFailed];
    cell.movieView.movieTitleLabel.text = movieData[@"title_kor"];
    [PCCommonUtility makeTextShadow:cell.movieView.movieTitleLabel opacity:0.9];
    
    cell.movieSelectButton.tag = indexPath.row;
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.#"];
    NSString *formattedString = [fmt stringFromNumber:movieData[@"star_average"]];
    cell.movieView.movieRatingLabel.text = [NSString stringWithFormat:@"평균 %@점", formattedString];
    [PCCommonUtility makeTextShadow:cell.movieView.movieRatingLabel opacity:0.9];
    
    cell.menuView.likeButton.selected = [movieData[@"is_like"] boolValue];
    cell.menuView.ratingButton.selected = [movieData[@"is_comment"] boolValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell" forIndexPath:indexPath];
    
    cell.menuView.likeButton.tag = indexPath.row;
    [cell.menuView.likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.menuView.ratingButton.tag = indexPath.row;
    [cell.menuView.ratingButton addTarget:self action:@selector(clickRatingButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)selectedMoive:(UIButton *)sender {

    [PCMovieDetailDataCenter sharedMovieDetailData].movieID = _recommendMovieList[sender.tag][@"id"];
}

- (void)clickLikeButton:(UIButton *)button {
    NSString *movieID = _recommendMovieList[button.tag][@"id"];
    [[PCUserInteractionHelper helperManager] changeLikeStateWithMovieID:movieID];
}

- (void)clickRatingButton:(UIButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    __block PCRecommendTableViewCell *cell = (PCRecommendTableViewCell *)[_recommendTableView cellForRowAtIndexPath:indexPath];
    
    NSString *movieID = _recommendMovieList[button.tag][@"id"];
    [[PCUserInteractionHelper helperManager] showRatingMovieViewWithMovieID:movieID andInteractionHandler:^{
        cell.menuView.ratingButton.selected = YES;
    }];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.bounds = CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight);
    headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:0.5];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    headerLabel.text = @"취향에 맞는 태그를 선택해보세요";
    headerLabel.font = [UIFont boldSystemFontOfSize:14.8f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
    [headerView addSubview:headerLabel];
    
    return headerView;
}



#pragma mark - Configure CustomRefreshControl
- (void)initCustomRefreshControl {
    refreshControl = [[UIRefreshControl alloc] init];
    
    // UIRefreshControl 배경
    self.refreshColorView = [[UIView alloc] initWithFrame:refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
    // 로딩이미지의 투명배경
    self.refreshLoadingView = [[UIView alloc] initWithFrame:refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // 로딩 이미지
    self.loadingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rating"]];
    
    [self.refreshLoadingView addSubview:self.loadingImg];
    self.refreshLoadingView.clipsToBounds = YES;
    
    // 기존 로딩이미지 icon 숨기기
    refreshControl.tintColor = [UIColor clearColor];
    
    [refreshControl addSubview:self.refreshColorView];
    [refreshControl addSubview:self.refreshLoadingView];
    
    self.isRefreshAnimating = NO;
    
    // 리프레시 이벤트 연결
    [refreshControl addTarget:self action:@selector(handleRefreshForCustom:) forControlEvents:UIControlEventValueChanged];
    
    [self.recommendTableView addSubview:refreshControl];
}


- (void)handleRefreshForCustom:(UIRefreshControl *)sender {
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect refreshBounds = refreshControl.bounds;
    CGFloat pullDistance = MAX(0.0, - refreshControl.frame.origin.y);
    CGFloat midX = self.recommendTableView.frame.size.width / 2.0;
    
    // 로딩이미지 RefreshControl의 중간에 위치하도록 계산
    CGFloat loadingImgHeight = self.loadingImg.bounds.size.height;
    CGFloat loadingImgHeightHalf = loadingImgHeight / 2.0;
    CGFloat loadingImgWidth = self.loadingImg.bounds.size.width;
    CGFloat loadingImgWidthHalf = loadingImgWidth / 2.0;
    
    CGFloat loadingImgY = pullDistance / 2.0 - loadingImgHeightHalf;
    CGFloat loadingImgX = midX - loadingImgWidthHalf;
    
    CGRect loadingImgFrame = self.loadingImg.frame;
    loadingImgFrame.origin.x = loadingImgX;
    loadingImgFrame.origin.y = loadingImgY;
    
    self.loadingImg.frame = loadingImgFrame;
    
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    if (refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
}


- (void)animateRefreshView {
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
    static int colorIndex = 0;
    
    self.isRefreshAnimating = YES;
    
    [self requestRecommendMovieList];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.loadingImg setTransform:CGAffineTransformRotate(self.loadingImg.transform, M_PI_2)];
                         
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         if (refreshControl.isRefreshing) {
                             [self animateRefreshView];
                         } else {
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation {
    self.isRefreshAnimating = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}


#pragma mark -
- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
