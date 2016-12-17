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

@interface PCMovieDetailViewController () <UIScrollViewDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryLayerHeight;
@property (weak, nonatomic) IBOutlet UIView *movieActorListView;
@property NSMutableArray *actorNameArray;
@property NSMutableArray *actorImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *moviePhotoCollectionView;
@property (weak, nonatomic) IBOutlet UIView *movieScoreGraphView;
@property (weak, nonatomic) IBOutlet UITableView *userReactionTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userReactionTableViewHeight;

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

@property NSArray *testArray;
@property NSURLSessionDataTask *detailHandler;
@property NSURLSessionDataTask *commentHandler;
@property NSURLSessionDataTask *bestCommentHandler;
@property NSURLSessionDataTask *famousLineHandler;
@property NSURLSessionDataTask *bestFamousLineHandler;

@end


@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDetailManager = [[PCMovieDetailManager alloc] init];
    self.movieDataCenter = [PCMovieDetailDataCenter sharedMovieDetailData];

    self.testArray = @[@"0",@"10",@"5",@"20",@"10",@"15",@"13",@"14",@"0",@"7",@"10",@"0"];
    
    self.userReactionTableView.rowHeight = UITableViewAutomaticDimension;
    self.userReactionTableView.estimatedRowHeight = 150;
    
    [self infoRequest];
    
    [self setCustomViewStatus];
}

-(void)viewDidLayoutSubviews{

    NSLog(@"dmdkdk : %lf", _userReactionTableView.contentSize.height);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)infoRequest{
    
    self.detailHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
        
        if (!error) {
            
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary = data;
            [self makeMovieDetailContents];
        }
    }];
    
    [self.detailHandler resume];
    
//    self.commentHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
//        
//        if (!error) {
//            
//            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList = data;
//        }
//    }];
//    
//    [self.commentHandler resume];
//    
//    self.bestCommentHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
//        
//        if (!error) {
//            
//            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList = data;
//            
//        }
//    }];
//    
//    [self.bestCommentHandler resume];
//    
//    self.famousLineHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
//        
//        if (!error) {
//            
//            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList = data;
//            [self makeMovieContents];
//        }
//    }];
//    
//    [self.famousLineHandler resume];
//    
//    self.bestFamousLineHandler = [self.movieDetailManager requestMovieDetailData:^(NSURLResponse *reponse, id data, NSError *error) {
//        
//        if (!error) {
//            
//            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList = data;
//            [self makeMovieContents];
//        }
//    }];
//    
//    [self.bestFamousLineHandler resume];
}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{
    
    
//    CGRect reactionTableViewHeight = _userReactionTableView.frame;
//    reactionTableViewHeight.size.height = _userReactionTableView.contentSize.height;
//
//    self.userReactionTableViewHeight.constant = reactionTableViewHeight.size.height;
//    
////    self.scrollContentViewHeight.constant = _scrollContentViewHeight.constant + self.userReactionTableViewHeight.constant;
    NSLog(@"%lf", _userReactionTableView.contentSize.height);
    
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
    
    // 영화 상단 흰글자 쉐도우
    self.movieTitleLabel.layer.masksToBounds = NO;
    self.movieTitleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.movieTitleLabel.layer.shadowRadius = 2;
    self.movieTitleLabel.layer.shadowOpacity = 0.8;
    
    self.movieStarAvergeLabel.layer.masksToBounds = NO;
    self.movieStarAvergeLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.movieStarAvergeLabel.layer.shadowRadius = 2;
    self.movieStarAvergeLabel.layer.shadowOpacity = 0.8;
    
    self.actorNameArray = [[NSMutableArray alloc] init];
    self.actorImageArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 3; i += 1) {
        
        CGFloat baseMovieContentWidth = self.movieActorListView.frame.size.width/3;
        CGFloat baseMovieContentHeight = [self ratioHeight:125];
        
        UIView *actorView = [[UIView alloc] init];
        actorView.tag = i;
        NSInteger row = actorView.tag%3;
        actorView.frame = CGRectMake(baseMovieContentWidth * row,0,
                                     baseMovieContentWidth,baseMovieContentHeight);
        
        [self.movieActorListView addSubview:actorView];
        
        UIImageView *actorImage = [[UIImageView alloc] init];
        
        actorImage.tag = i;
        actorImage.frame = CGRectMake(actorView.frame.size.width/2 - [self ratioWidth:35], 0, [self ratioWidth:70], [self ratioHeight:70]);
        actorImage.layer.cornerRadius = [self ratioWidth:35];
        actorImage.contentMode = UIViewContentModeScaleAspectFill;
        actorImage.clipsToBounds = YES;
        
        [self.actorImageArray addObject:actorImage];
        
        [actorView addSubview:actorImage];
        
        UILabel *actorName = [[UILabel alloc] init];
        
        actorName.frame = CGRectMake(0, [self ratioHeight:85], actorView.frame.size.width, [self ratioHeight:20]);
        actorName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        actorName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        actorName.textAlignment = NSTextAlignmentCenter;
        
        [self.actorNameArray addObject:actorName];
        
        [actorView addSubview:actorName];
    }
    
    self.movieTrailerButton.imageEdgeInsets = UIEdgeInsetsMake(20, 35, 20, 35);
    
    BEMSimpleLineGraphView *movieScoreGraph = [[BEMSimpleLineGraphView alloc] init];
    movieScoreGraph.frame = CGRectMake(0, 0, self.movieScoreGraphView.frame.size.width, self.movieScoreGraphView.frame.size.height);
    movieScoreGraph.dataSource = self;
    movieScoreGraph.delegate = self;
    movieScoreGraph.enableBezierCurve = YES;
    movieScoreGraph.colorTop = [UIColor whiteColor];
    movieScoreGraph.colorBottom = [UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1];
    movieScoreGraph.displayDotsWhileAnimating = NO;
    [self.movieScoreGraphView addSubview:movieScoreGraph];

}

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
    
    for (NSInteger j = 0; j < 3; j += 1) {
        
        UILabel *actorName = self.actorNameArray[j];
        actorName.text = [self.movieDataCenter creatMovieActorName][j];
    
        UIImageView *actorImage = self.actorImageArray[j];
        [actorImage sd_setImageWithURL:[self.movieDataCenter creatMovieActorImage][j]];
    }
    
    self.movieStarAvergeLabel.text = [NSString stringWithFormat:@"평균 %@",[self.movieDataCenter creatStarAverage]];
    self.movieStarScore.value = [[self.movieDataCenter creatStarAverage] floatValue];
    
    [self.movieTrailerImage sd_setImageWithURL:[self.movieDataCenter creatMovieMainImage]];
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
    
    [moviePhotoCell.moviePhotoImageView sd_setImageWithURL:[_movieDataCenter creatMoviePhoto][indexPath.row] ];
    moviePhotoCell.moviePhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    moviePhotoCell.moviePhotoImageView.clipsToBounds = YES;
    
    return moviePhotoCell;
}

#pragma mark - TableView Delegate Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestCommentCell" forIndexPath:indexPath];
        
        return cell;
        
    }else if (indexPath.section == 1) {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestFamousLineCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Graph OpenSource Required
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph{
    
    return self.testArray.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index{
    
    return [[self.testArray objectAtIndex:index] doubleValue];;
}

#pragma mark - MovieStory More Button Action
- (IBAction)moreStoryViewButton:(id)sender {
    
    self.movieStoryTextView.scrollEnabled = YES;
    
    [self.movieStoryMoreButton setTitle:@"닫기" forState:UIControlStateNormal];
    
    CGRect textViewFrame = _movieStoryTextView.frame;
    textViewFrame.size.height = _movieStoryTextView.contentSize.height;
    
    if ([self.movieStoryMoreButton.titleLabel.text isEqualToString:@"더보기"]) {
        
        self.scrollContentViewHeight.constant = (_scrollContentViewHeight.constant + (textViewFrame.size.height - 55));
        self.movieStoryLayerHeight.constant = (_movieStoryLayerHeight.constant + (textViewFrame.size.height - 55));
        self.movieStoryTextViewHeight.constant = textViewFrame.size.height;
        
    }else{
    
        self.scrollContentViewHeight.constant = (_scrollContentViewHeight.constant - (textViewFrame.size.height - 55));
        self.movieStoryLayerHeight.constant = (_movieStoryLayerHeight.constant - (textViewFrame.size.height - 55));
        self.movieStoryTextViewHeight.constant = 55;
        
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
