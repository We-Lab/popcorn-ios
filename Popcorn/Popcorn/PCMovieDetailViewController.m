//
//  PCMovieDetailViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailViewController.h"
#import <HCSStarRatingView.h>
#import <BEMSimpleLineGraphView.h>
#import <UIImageView+WebCache.h>

#import "PCNetworkParamKey.h"
#import "PCMovieDetailManager.h"
#import "PCMovieDetailDataCenter.h"
#import "PCBestCommentCustomCell.h"
#import "PCBestFamousLineCustomCell.h"
#import "PCMoviePhotoCell.h"
#import "PCCommentViewController.h"
#import "PCFamousLineViewController.h"

@interface PCMovieDetailViewController () <UIScrollViewDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, UITableViewDelegate, UITableViewDataSource>

@property PCMovieDetailManager *movieDetailManager;
@property PCMovieDetailDataCenter *movieDataCenter;
@property HCSStarRatingView *movieStarScore;

@property (weak, nonatomic) IBOutlet UIView *starScoreView;
@property (weak, nonatomic) IBOutlet UIView *moviePosterView;

@property (weak, nonatomic) IBOutlet UIView *movieInfoButtonView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *movieStoryMoreButton;
@property (weak, nonatomic) IBOutlet UIView *movieActorListView;
@property (weak, nonatomic) IBOutlet UICollectionView *moviePhotoCollectionView;
@property (weak, nonatomic) IBOutlet UIView *movieScoreGraphView;
@property (weak, nonatomic) IBOutlet UITableView *userReactionTableView;


// Movie Content Property
@property (weak, nonatomic) IBOutlet UIImageView *movieMainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRuningTimeGenreLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDateNationLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieGradeLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieStoryTextView;
@property (weak, nonatomic) IBOutlet UIImageView *movieTrailerImage;
@property (weak, nonatomic) IBOutlet UILabel *movieStarAvergeLabel;
@property (weak, nonatomic) IBOutlet UIButton *movieTrailerButton;
@property (weak, nonatomic) IBOutlet UILabel *graphStarAverrge;
@property (weak, nonatomic) IBOutlet UILabel *graphStarCount;
@property (weak, nonatomic) IBOutlet UILabel *graphTopScore;
@property BEMSimpleLineGraphView *starGraph;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryLayerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userReactionTableViewHeight;

@property NSURLSessionDataTask *detailHandler;
@property NSURLSessionDataTask *commentHandler;
@property NSURLSessionDataTask *bestCommentHandler;
@property NSURLSessionDataTask *famousLineHandler;
@property NSURLSessionDataTask *bestFamousLineHandler;

@property NSMutableArray *actorNameArray;
@property NSMutableArray *actorImageArray;
@property NSMutableArray *actorMovieNmaeArray;
@property NSArray *testArray;

@property UIActivityIndicatorView *activityIndicatorView;

@end


@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDetailManager = [[PCMovieDetailManager alloc] init];
    self.movieDataCenter = [PCMovieDetailDataCenter sharedMovieDetailData];

    self.userReactionTableView.rowHeight = UITableViewAutomaticDimension;
    self.userReactionTableView.estimatedRowHeight = 150;

    [self setCustomViewStatus];
    [self startActivityIndicatorAnimating];
    [self infoRequest];
}

-(void)viewDidLayoutSubviews{

    CGRect reactionTableViewHeight = _userReactionTableView.frame;
    reactionTableViewHeight.size.height = _userReactionTableView.contentSize.height;
    
    self.userReactionTableViewHeight.constant = reactionTableViewHeight.size.height;
    
    self.scrollContentViewHeight.constant = 1290 + self.userReactionTableViewHeight.constant;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.userReactionTableView reloadData];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)startActivityIndicatorAnimating {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidden = NO;
    [self.view addSubview:_activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
}

- (void)infoRequest{
    
    // Movie Detail Data
    self.detailHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary = data;
            [self makeMovieDetailContents];
            [self.activityIndicatorView stopAnimating];
        }
    }];
    [self.detailHandler resume];
    
    // Movie Star Histogram
    self.detailHandler = [self.movieDetailManager requestMovieDetailStarGraphData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailStarHistogramList = data;
            [self.starGraph reloadGraph];
        }
    }];
    [self.detailHandler resume];
    
    // Movie Best Comment
    self.bestCommentHandler = [self.movieDetailManager requestMovieDetailBestCommentData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList = data;
            if (self.movieDataCenter.movieDetailBestCommentList.count != 0) {
                [self.userReactionTableView reloadData];
            }
        }
    }];
    [self.bestCommentHandler resume];
    
    // Movie Best FamousLine
    self.bestFamousLineHandler = [self.movieDetailManager requestMovieDetailBestFamousLineData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList = data;
            
            if (self.movieDataCenter.movieDetailBestFamousLineList.count != 0) {
                [self.userReactionTableView reloadData];
            }
        }
    }];
    [self.bestFamousLineHandler resume];
    
    // Movie Comment
    self.commentHandler = [self.movieDetailManager requestMovieDetailCommentData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList = data[@"results"];
        }
    }];
    [self.commentHandler resume];

    // Movie FamousLine
    self.famousLineHandler = [self.movieDetailManager requestMovieDetailFamousLineData:^(NSURLResponse *reponse, id data, NSError *error) {
        if (!error) {
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList = data[@"results"];
        }
    }];
    [self.famousLineHandler resume];
    

}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{
    
    // 포스터
    self.moviePosterView.layer.masksToBounds = NO;
    self.moviePosterView.layer.shadowOffset = CGSizeMake(0, 1);
    self.moviePosterView.layer.shadowRadius = 2;
    self.moviePosterView.layer.shadowOpacity = 0.3;
    
    // 영화 별점 이미지
    self.movieStarScore = [[HCSStarRatingView alloc] init];
    self.movieStarScore.frame = CGRectMake(0, 0, self.starScoreView.frame.size.width, self.starScoreView.frame.size.height);
    self.movieStarScore.maximumValue = 5;
    self.movieStarScore.minimumValue = 0;
    self.movieStarScore.backgroundColor = [UIColor clearColor];
    self.movieStarScore.allowsHalfStars = YES;
    self.movieStarScore.accurateHalfStars = YES;
    self.movieStarScore.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    self.movieStarScore.filledStarImage = [UIImage imageNamed:@"FullStar"];
    self.movieStarScore.userInteractionEnabled = NO;
    [self.starScoreView addSubview:self.movieStarScore];
    
    // 커스텀 버튼
    [self makeCustomButtom:self.likeButton title:@"좋아요" imageName:[UIImage imageNamed:@"Rating"]];
    [self makeCustomButtom:self.ratingButton title:@"평가하기" imageName:[UIImage imageNamed:@"Ranking"]];
    [self makeCustomButtom:self.commentButton title:@"코멘트" imageName:[UIImage imageNamed:@"Recommend"]];
    [self makeCustomButtom:self.moreInfoButton title:@"더보기" imageName:[UIImage imageNamed:@"More"]];
    
    // 줄거리 더보기
    self.movieInfoButtonView.layer.borderWidth = 1;
    self.movieInfoButtonView.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    [self.movieStoryMoreButton setTitle:@"더보기" forState:UIControlStateNormal];
    
    [PCCommonUtility makeTextShadow:self.movieTitleLabel opacity:0.8];
    [PCCommonUtility makeTextShadow:self.movieStarAvergeLabel opacity:0.8];
    
    self.actorImageArray = [[NSMutableArray alloc] init];
    self.actorMovieNmaeArray = [[NSMutableArray alloc] init];
    self.actorNameArray = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < 3; i += 1) {
        
        CGFloat baseMovieContentWidth = self.movieActorListView.frame.size.width/3;
        CGFloat baseMovieContentHeight = [self ratioHeight:130];
        
        UIView *actorView = [[UIView alloc] init];
        actorView.tag = i;
        NSInteger row = actorView.tag%3;
        actorView.frame = CGRectMake(baseMovieContentWidth * row,0,
                                     baseMovieContentWidth,baseMovieContentHeight);
        
        [self.movieActorListView addSubview:actorView];
        
        UIImageView *actorImage = [[UIImageView alloc] init];
        
        actorImage.tag = i;
        actorImage.frame = CGRectMake(actorView.frame.size.width/2 - [self ratioWidth:35], 0, [self ratioWidth:70], [self ratioHeight:70]);
        actorImage.backgroundColor = [UIColor lightGrayColor];
        actorImage.layer.cornerRadius = [self ratioWidth:35];
        actorImage.contentMode = UIViewContentModeScaleAspectFill;
        actorImage.clipsToBounds = YES;
        
        [self.actorImageArray addObject:actorImage];
        
        [actorView addSubview:actorImage];
        
        UILabel *actorName = [[UILabel alloc] init];
        
        actorName.frame = CGRectMake(0, [self ratioHeight:80], actorView.frame.size.width, [self ratioHeight:20]);
        actorName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        actorName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        actorName.textAlignment = NSTextAlignmentCenter;
        actorName.text = @"배우이름";
        
        [self.actorNameArray addObject:actorName];
        
        [actorView addSubview:actorName];
        
        UILabel *actorMovieName = [[UILabel alloc] init];
        
        actorMovieName.frame = CGRectMake(0, [self ratioHeight:100], actorView.frame.size.width, [self ratioHeight:20]);
        actorMovieName.font = [UIFont systemFontOfSize:12];
        actorMovieName.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1];
        actorMovieName.textAlignment = NSTextAlignmentCenter;
        actorMovieName.text = @"배역이름";
        
        [self.actorMovieNmaeArray addObject:actorMovieName];
        
        [actorView addSubview:actorMovieName];
    }
    
    self.movieTrailerButton.imageEdgeInsets = UIEdgeInsetsMake(20, 35, 20, 35);

    self.starGraph = [[BEMSimpleLineGraphView alloc] init];
    
    self.starGraph.frame = CGRectMake(0, 0, self.movieScoreGraphView.frame.size.width, self.movieScoreGraphView.frame.size.height);
    self.starGraph.dataSource = self;
    self.starGraph.delegate = self;
    self.starGraph.enableBezierCurve = YES;
    self.starGraph.colorTop = [UIColor whiteColor];
    self.starGraph.colorBottom = [UIColor clearColor];
    self.starGraph.colorLine = [UIColor whiteColor];
    
    [self.movieScoreGraphView addSubview:self.starGraph];

}

#pragma mark - Set the Movie data
- (void)makeMovieDetailContents {

    [self.navigationItem setTitle:[self.movieDataCenter creatMovieTitle]];
    
    self.movieTitleLabel.text = [self.movieDataCenter creatMovieTitle];
    self.movieRuningTimeGenreLabel.text = [NSString stringWithFormat:@"%@ | %@",[self.movieDataCenter creatMovieRunningTime],[self.movieDataCenter creatMovieGenre]];
    self.movieDateNationLabel.text = [NSString stringWithFormat:@"%@ | %@",[self.movieDataCenter creatMovieDate],[self.movieDataCenter creatMovieNation]];
    self.movieGradeLabel.text = [self.movieDataCenter creatMovieGrade];
    self.movieStoryTextView.text = [self.movieDataCenter creatMovieStory];
    [self.movieMainImage sd_setImageWithURL:[self.movieDataCenter creatMovieMainImage]];
    [self.moviePosterImage sd_setImageWithURL:[self.movieDataCenter creatMoviePosterImage]];
    
    [self.moviePhotoCollectionView reloadData];
    [self.userReactionTableView reloadData];
    
    for (NSInteger j = 0; j < 3; j += 1) {
        
        UILabel *actorName = self.actorNameArray[j];
        actorName.text = [self.movieDataCenter creatMovieActorName][j];
        
        UILabel *actorMovieName = self.actorMovieNmaeArray[j];
        
        actorMovieName.text = [self.movieDataCenter creatMovieActorMovieName][j];
    
        UIImageView *actorImage = self.actorImageArray[j];
        [actorImage sd_setImageWithURL:[self.movieDataCenter creatMovieActorImage][j]];
    }
    
    self.movieStarAvergeLabel.text = [NSString stringWithFormat:@"평균 %.2lf",[[self.movieDataCenter creatStarAverage] floatValue]];
    self.movieStarScore.value = [[self.movieDataCenter creatStarAverage] floatValue];
    
    [self.movieTrailerImage sd_setImageWithURL:[self.movieDataCenter creatMovieMainImage]];
    
    self.graphStarAverrge.text = [NSString stringWithFormat:@"%.2lf",[[self.movieDataCenter creatStarAverage] floatValue]];
    self.graphStarCount.text = [NSString stringWithFormat:@"%ld", [[self.movieDataCenter creatMovieCommentCount] integerValue]];
}

#pragma mark - Make Custom button
- (void)makeCustomButtom:(UIButton *)button title:(NSString *)title imageName:(UIImage *)imageName{

    [button setImage:imageName forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];

    CGFloat spacing = 6.0;

    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);

    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height), 0.0, 0.0, - titleSize.width);

    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

#pragma mark - CollectionView Delegate Required
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_movieDataCenter creatMoviePhoto].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PCMoviePhotoCell *moviePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePhotoCell" forIndexPath:indexPath];
    
    [moviePhotoCell.moviePhotoImageView sd_setImageWithURL:[_movieDataCenter creatMoviePhoto][indexPath.row]];
    moviePhotoCell.moviePhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    moviePhotoCell.moviePhotoImageView.clipsToBounds = YES;
    
    return moviePhotoCell;
}

#pragma mark - TableView Delegate Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.movieDataCenter.movieDetailBestCommentList.count == 0) {
            return 1;
        }else{
            return self.movieDataCenter.movieDetailBestCommentList.count;
        }

    }else if (section == 1){
    
        if (self.movieDataCenter.movieDetailBestFamousLineList.count == 0) {
            return 1;
        }else{
            return self.movieDataCenter.movieDetailBestFamousLineList.count;
        }
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.movieDataCenter.movieDetailBestCommentList.count == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCommnetCell" forIndexPath:indexPath];
            
            return cell;
        }else{
            
            PCBestCommentCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestCommentCell" forIndexPath:indexPath];
            
            HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
            starRatingView.frame = CGRectMake(0, 0, 120, cell.bestCommentStarScoreView.frame.size.height);
            starRatingView.maximumValue = 5;
            starRatingView.minimumValue = 0;
            starRatingView.backgroundColor = [UIColor clearColor];
            starRatingView.allowsHalfStars = YES;
            starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
            starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
            starRatingView.userInteractionEnabled = NO;
            [cell.bestCommentStarScoreView addSubview:starRatingView];
            
            cell.bestCommentUserID.text = [self.movieDataCenter creatBestCommentUserID][indexPath.row];
            starRatingView.value = [[self.movieDataCenter creatBestCommentUserStar][indexPath.row] floatValue];
            cell.bestCommentText.text = [self.movieDataCenter creatBestCommentUserText][indexPath.row];
            cell.bestCommentLikeText.text = [NSString stringWithFormat:@"%@ 명이 좋아합니다.", [self.movieDataCenter creatBestCommentLikeCount][indexPath.row]];
            NSString *commentDate =[[self.movieDataCenter creatBestCommentWriteDate][indexPath.row] substringWithRange:NSMakeRange(0, 10)];
            cell.bestCommentWriteDate.text = commentDate;
            [cell.bestCommentUserImage sd_setImageWithURL:[self.movieDataCenter creatBestCommentUserImage][indexPath.row]];

            return cell;
        }
        
    }
    
    else if (indexPath.section == 1) {
        
        if (self.movieDataCenter.movieDetailBestFamousLineList.count == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultFamousLineCell" forIndexPath:indexPath];
            
            return cell;
        }else{
            
            PCBestFamousLineCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestFamousLineCell" forIndexPath:indexPath];
            
            cell.bestFamousLineUserID.text = [self.movieDataCenter creatBestFamousLineUserID][indexPath.row];
            cell.bestFamousLineMovieName.text
            = [NSString stringWithFormat:@"%@ | %@",[self.movieDataCenter creatBestFamousLineActorName][indexPath.row],
               [self.movieDataCenter creatBestFamousLineMovieName][indexPath.row]];
            cell.bestFamousLineText.text = [self.movieDataCenter creatBestFamousLineUserText][indexPath.row];
            cell.bestFamousLineLikeText.text = [NSString stringWithFormat:@"%@ 명이 좋아합니다.",[self.movieDataCenter creatBestFamousLineLikeCount][indexPath.row]];
            NSString *commentDate =[[self.movieDataCenter creatBestFamousLineWriteDate][indexPath.row] substringWithRange:NSMakeRange(0, 10)];
            cell.bestFamousLineWriteDate.text = commentDate;
            [cell.bestFamousLineActorImage sd_setImageWithURL:[self.movieDataCenter creatBestFamousLineActorImage][indexPath.row]];
            
            return cell;
            
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return [self ratioHeight:47];
    }
    
    return [self ratioHeight:32];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionHeaderView = [[UIView alloc] init];

    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.frame = CGRectMake([self ratioWidth:12], [self ratioHeight:12], tableView.frame.size.width - [self ratioWidth:12], [self ratioHeight:20]);
    headerTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    headerTitle.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
    
    [sectionHeaderView addSubview:headerTitle];
    
    if (section == 0) {
        sectionHeaderView.frame = CGRectMake(0, 0, tableView.frame.size.width, [self ratioHeight:32]);
        headerTitle.frame = CGRectMake([self ratioWidth:12], [self ratioHeight:12], tableView.frame.size.width - [self ratioWidth:12], [self ratioHeight:20]);
        headerTitle.text = @"코멘트";
        
    }else if(section == 1){
        sectionHeaderView.frame = CGRectMake(0, 0, tableView.frame.size.width, [self ratioHeight:47]);
        
        UIView *sectionMargin = [[UIView alloc] init];
        sectionMargin.frame = CGRectMake(0, 0, tableView.frame.size.width, [self ratioHeight:15]);
        sectionMargin.backgroundColor = [UIColor colorWithRed:248.f/255.f green:247.f/255.f blue:248.f/255.f alpha:1];
        [sectionHeaderView addSubview:sectionMargin];
        
        headerTitle.frame = CGRectMake([self ratioWidth:12], [self ratioHeight:27], tableView.frame.size.width - [self ratioWidth:12], [self ratioHeight:20]);
        headerTitle.text = @"명대사";
    }
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return [self ratioHeight:45];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *sectionFooterView = [[UIView alloc] init];
    
    sectionFooterView.frame = CGRectMake(0, 0, tableView.frame.size.width, [self ratioHeight:45]);
    sectionFooterView.backgroundColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1];
    
    UIButton *moreButton = [[UIButton alloc] init];
    
    moreButton.frame = CGRectMake(0, [self ratioHeight:1], tableView.frame.size.width, [self ratioHeight:44]);
    moreButton.backgroundColor = [UIColor whiteColor];
    [moreButton setTitle:@"더보기" forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreButton setTitleColor:[UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1] forState:UIControlStateNormal];
    
    if (section == 0) {
        [moreButton addTarget:self action:@selector(moveToCommentList) forControlEvents:UIControlEventTouchUpInside];
    }else if (section == 1){
        [moreButton addTarget:self action:@selector(moveToFamousLineList) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [sectionFooterView addSubview:moreButton];
    
    return sectionFooterView;
}

- (void)moveToCommentList {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieInfo" bundle:nil];
    PCCommentViewController *commnetVC = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    [self.navigationController pushViewController:commnetVC animated:YES];
}

- (void)moveToFamousLineList {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieInfo" bundle:nil];
    PCFamousLineViewController *famousLineVC = [storyboard instantiateViewControllerWithIdentifier:@"FamousLineViewController"];
    [self.navigationController pushViewController:famousLineVC animated:YES];
}

#pragma mark - Graph OpenSource Required
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph{
    
    return (int)[self.movieDataCenter creatMovieStarHistogram].count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index{
    
    return [[[self.movieDataCenter creatMovieStarHistogram] objectAtIndex:index] doubleValue];
}

#pragma mark - MovieStory More Button Action
- (IBAction)moreStoryViewButton:(id)sender {
    
    self.movieStoryTextView.scrollEnabled = YES;
    
    [self.movieStoryMoreButton setTitle:@"닫기" forState:UIControlStateNormal];
    
    CGRect textViewFrame = _movieStoryTextView.frame;
    textViewFrame.size.height = _movieStoryTextView.contentSize.height;
    
    if ([self.movieStoryMoreButton.titleLabel.text isEqualToString:@"더보기"]) {
        
        self.scrollContentViewHeight.constant = (_scrollContentViewHeight.constant + (textViewFrame.size.height - 53));
        self.movieStoryLayerHeight.constant = (_movieStoryLayerHeight.constant + (textViewFrame.size.height - 53));
        self.movieStoryTextViewHeight.constant = textViewFrame.size.height;
        
    }else{
    
        self.scrollContentViewHeight.constant = (_scrollContentViewHeight.constant - (textViewFrame.size.height - 53));
        self.movieStoryLayerHeight.constant = (_movieStoryLayerHeight.constant - (textViewFrame.size.height - 53));
        self.movieStoryTextViewHeight.constant = 53;
        
        self.movieStoryTextView.scrollEnabled = NO;
        
        [self.movieStoryMoreButton setTitle:@"더보기" forState:UIControlStateNormal];
    }
    
}

- (IBAction)movieRatingStar:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"영화를 평가해주세요.\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIView *starRatingView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 250, 50)];
    [starRatingView setBackgroundColor:[UIColor clearColor]];
    [alert.view addSubview:starRatingView];
    
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
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
        self.ratingButton.tintColor = [UIColor colorWithRed:29.0/255.0 green:140.0/255.0 blue:249.0/255.0 alpha:1];
    }];
}


#pragma mark - Custom Method
- (CGFloat)ratioWidth:(NSInteger)num{
    return (num * self.view.frame.size.width) / 375;
}

- (CGFloat)ratioHeight:(NSInteger)num{
    return (num * self.view.frame.size.height) / 667;
}

- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
