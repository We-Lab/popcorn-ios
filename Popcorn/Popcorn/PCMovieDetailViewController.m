//
//  PCMovieDetailViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailViewController.h"
#import "PCMovieNaviView.h"
#import <HCSStarRatingView.h>
#import <BEMSimpleLineGraphView.h>

#import "PCNetworkParamKey.h"
#import "PCMovieDetailManager.h"
#import "PCMovieDetailDataCenter.h"
#import <UIImageView+WebCache.h>

@interface PCMovieDetailViewController () <UIScrollViewDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property PCMovieDetailManager *movieDetailManager;
@property PCMovieDetailDataCenter *movieDataCenter;

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
@property NSMutableArray *actorArray;

@property (weak, nonatomic) IBOutlet UIView *commentContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContentHeight;
@property (weak, nonatomic) IBOutlet UIView *famousLineContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *famousLineContentHeight;
@property (weak, nonatomic) IBOutlet UIView *movieScoreGraphView;

// Movie Content Property
@property (weak, nonatomic) IBOutlet UIImageView *movieMainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRuningTimeGenreLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDateNationLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieGradeLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieStoryTextView;
@property (weak, nonatomic) IBOutlet UIImageView *movieThumnailImage;

@property NSArray *testArray;

@end

@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDetailManager = [[PCMovieDetailManager alloc] init];
    self.movieDataCenter = [[PCMovieDetailDataCenter alloc] init];
    
    [self.movieDetailManager requestMovieDetailData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(makeMovieContents)
                                                 name:movieDataRequestNotification
                                               object:nil];
    
    self.testArray = @[@"0",@"10",@"5",@"20",@"10",@"15",@"13",@"14",@"0",@"7",@"10",@"0"];
    [self preferredStatusBarStyle];
    [self setCustomViewStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Make Custom Navi View
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y < 50) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        
    }else if (scrollView.contentOffset.y >= 50){
    
        [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage alloc];
    }
}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{

    self.moviePosterView.layer.masksToBounds = NO;
    self.moviePosterView.layer.shadowOffset = CGSizeMake(0, 1);
    self.moviePosterView.layer.shadowRadius = 2;
    self.moviePosterView.layer.shadowOpacity = 0.3;
    
    HCSStarRatingView *movieStarScore = [[HCSStarRatingView alloc] init];
    movieStarScore.frame = CGRectMake(0, 0, self.starScoreView.frame.size.width, self.starScoreView.frame.size.height);
    movieStarScore.maximumValue = 5;
    movieStarScore.minimumValue = 0;
    movieStarScore.value = 3.3;
    movieStarScore.backgroundColor = [UIColor clearColor];
    movieStarScore.allowsHalfStars = YES;
    movieStarScore.accurateHalfStars = YES;
    movieStarScore.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    movieStarScore.filledStarImage = [UIImage imageNamed:@"FullStar"];
    movieStarScore.userInteractionEnabled = NO;
    [self.starScoreView addSubview:movieStarScore];
    
    self.movieInfoButtonView.layer.borderWidth = 1;
    self.movieInfoButtonView.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    
    [self makeCustomButtom:self.likeButton title:@"좋아요" imageName:[UIImage imageNamed:@"Rating"]];
    [self makeCustomButtom:self.ratingButton title:@"평가하기" imageName:[UIImage imageNamed:@"Ranking"]];
    [self makeCustomButtom:self.commentButton title:@"코멘트" imageName:[UIImage imageNamed:@"Recommend"]];
    [self makeCustomButtom:self.moreInfoButton title:@"더보기" imageName:[UIImage imageNamed:@"More"]];
    
    [self.movieStoryMoreButton setTitle:@"더보기" forState:UIControlStateNormal];
    
    self.actorArray = [[NSMutableArray alloc] init];
    
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
        
        actorImage.frame = CGRectMake(actorView.frame.size.width/2 - [self ratioWidth:35], 0, [self ratioWidth:70], [self ratioHeight:70]);
        actorImage.layer.cornerRadius = [self ratioWidth:35];
        actorImage.backgroundColor = [UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1];
        
        [actorView addSubview:actorImage];
        
        UILabel *actorName = [[UILabel alloc] init];
        
        actorName.frame = CGRectMake(0, [self ratioHeight:85], actorView.frame.size.width, [self ratioHeight:20]);
        actorName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        actorName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        actorName.textAlignment = NSTextAlignmentCenter;
        
        [self.actorArray addObject:actorName];
        
        [actorView addSubview:actorName];

        if (i == 0) {
        
            UILabel *actorMovieName = [[UILabel alloc] init];
            
            actorMovieName.frame = CGRectMake(0, [self ratioHeight:105], actorView.frame.size.width, [self ratioHeight:20]);
            actorMovieName.text = @"감독";
            actorMovieName.font = [UIFont systemFontOfSize:13];
            actorMovieName.textColor = [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1];
            actorMovieName.textAlignment = NSTextAlignmentCenter;
            
            [actorView addSubview:actorMovieName];
        }
    }
    
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

- (void)makeMovieContents {
    
    PCMovieDetailDataCenter *dataCenter = [[PCMovieDetailDataCenter alloc] init];
    
    self.movieTitleLabel.text = [dataCenter creatMovieTitle];
    self.movieRuningTimeGenreLabel.text = [NSString stringWithFormat:@"%@ | %@",[dataCenter creatMovieRunningTime],[dataCenter creatMovieGenre]];
    self.movieDateNationLabel.text = [NSString stringWithFormat:@"%@ | %@",[dataCenter creatMovieDate],[dataCenter creatMovieNation]];
    self.movieGradeLabel.text = [dataCenter creatMovieGrade];
    self.movieStoryTextView.text = [dataCenter creatMovieStory];
    [self.movieMainImage sd_setImageWithURL:[dataCenter creatMovieMainImage]];
    [self.moviePosterImage sd_setImageWithURL:[dataCenter creatMoviePosterImage]];

    UILabel *directorLabel = self.actorArray[0];
    directorLabel.text = [dataCenter creatMovieDirectorName];
    UILabel *actor01Label = self.actorArray[1];
    actor01Label.text = [dataCenter creatMovieActorName][0];
    UILabel *actor02Label = self.actorArray[2];
    actor02Label.text = [dataCenter creatMovieActorName][1];
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

#pragma mark - Custom FamousLine View
- (void)setCustomMovieFamousLineView{
    
}

#pragma mark - CollectionView Required
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *moviePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePhotoCell" forIndexPath:indexPath];
    
    return moviePhotoCell;
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
