//
//  PCHomeViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCHomeViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView.h>

#import "PCBoxOfficeData.h"
#import "PCMovieDetailViewController.h"
#import "PCMovieInfoManager.h"
#import "PCMagazineCollectionViewCell.h"
#import "PCTodayRecommendTableViewCell.h"

@interface PCHomeViewController () <UIScrollViewDelegate, UITableViewDelegate>

// Base Scroll View
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

// Box Office
@property (weak, nonatomic) IBOutlet UIView *mainBoxOfficeView;
@property (nonatomic) UIView *movieSlidingContentView;
@property (nonatomic) UIScrollView *boxOfficeScrollView;
@property (nonatomic) NSArray *boxOfficeList;

// Magazine
@property (weak, nonatomic) IBOutlet UICollectionView *movieMagazineCollectionView;
@property (nonatomic) NSArray *magazineList;

// Best Comment
@property (weak, nonatomic) IBOutlet UILabel *bestCommentUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bestCommentTextView;
@property (weak, nonatomic) IBOutlet UILabel *bestCommentMovieTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *likeHeartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestCommentTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestCommentBaseViewHeight;
@property (nonatomic) BOOL likeReview;

// Today Recommend Movie
@property (weak, nonatomic) IBOutlet UITableView *todayRecommendMovieTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewControllHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecommendTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecommendViewHeight;
@property (nonatomic) NSArray *todayRecommendList;

@end

@implementation PCHomeViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    #ifndef DEBUG
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    #endif
}

- (void)createViews {
    [self requestBoxOfficeList];
    [self requestMagazineList];
    [self requestBestCommentAmongBoxOffice];
    [self requestTodayRecommendMovie];
}

#pragma mark -
#pragma mark Setting BoxOffice
- (void)requestBoxOfficeList {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
        if (isSuccess)
            [self didReceiveBoxOfficeList:resultArray];
    };
    
    [[PCMovieInfoManager movieManager] requestBoxOfficeListwithCompletionHandler:completionHandler];
}

- (void)didReceiveBoxOfficeList:(NSArray *)boxOfficeList {
    self.boxOfficeList = [NSArray array];
    self.boxOfficeList = boxOfficeList;
    [self creatMainBoxOffice];
    [self setCustomViewStatus];
}



#pragma mark - Configure Base View
- (void)setCustomViewStatus{
//    self.todayRecommendTableViewHeight.constant = [self ratioHeight:210] * self.magazineList.count;
//    self.viewControllHeight.constant = 1073 + self.todayRecommendTableViewHeight.constant;
//    self.todayRecommendViewHeight.constant = 47 + self.todayRecommendTableViewHeight.constant;
}

#pragma mark - BoxOffice Movie Scroll View
- (void)creatMainBoxOffice{
    self.boxOfficeScrollView = [[UIScrollView alloc] init];
    
    self.boxOfficeScrollView.frame = CGRectMake([self ratioWidth:40], 0, [self ratioWidth:295], [self ratioHeight:522]);
    self.boxOfficeScrollView.contentSize = CGSizeMake([self ratioWidth:3540], self.mainBoxOfficeView.frame.size.height);
    self.boxOfficeScrollView.contentOffset = CGPointMake([self ratioWidth:295], 0);
    self.boxOfficeScrollView.pagingEnabled = YES;
    self.boxOfficeScrollView.showsHorizontalScrollIndicator = NO;
    self.boxOfficeScrollView.delegate = self;
    self.boxOfficeScrollView.clipsToBounds = NO;
    self.boxOfficeScrollView.showsVerticalScrollIndicator = NO;
    self.boxOfficeScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.mainBoxOfficeView addSubview:self.boxOfficeScrollView];
    
    self.movieSlidingContentView = [[UIView alloc] init];
    self.movieSlidingContentView.frame = CGRectMake(0, [self ratioHeight:15], [self ratioWidth:3540], [self ratioHeight:507]);
    [self.boxOfficeScrollView addSubview:self.movieSlidingContentView];
    
    [self creatMovieRankScroll];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.movieMagazineCollectionView || scrollView == self.todayRecommendMovieTableView) {
        return;
    }
    else if (scrollView.contentOffset.x < scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*11-5, 0);
    }
    else if (scrollView.contentOffset.x > scrollView.frame.size.width*11-5){
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
}


#pragma mark - Main Movie Scroll Layout
- (void)creatMovieRankScroll{
    
    for(NSInteger i = 0; i < 12; i++){
        CGFloat baseContentMargin = [self ratioWidth:10];
        CGFloat baseMovieContentWidth = [self ratioWidth:295];
        CGFloat baseMovieContentHeight = [self ratioHeight:507];
        
        NSDictionary *movieInfo = [NSDictionary dictionary];
        if (i == 0)
            movieInfo = _boxOfficeList[9];
        else if (i == 11)
            movieInfo = _boxOfficeList[0];
        else
            movieInfo = _boxOfficeList[i-1];
        
        UIView *movieContentView = [[UIView alloc] init];
        movieContentView.tag = i;
        NSInteger row = movieContentView.tag;
        movieContentView.frame = CGRectMake(baseMovieContentWidth * row,0,
                                            baseMovieContentWidth,baseMovieContentHeight);
        [self.movieSlidingContentView addSubview:movieContentView];
        
        
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.frame = CGRectMake(baseContentMargin, 0, [self ratioWidth:275], [self ratioHeight:394]);
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        posterImageView.clipsToBounds = YES;
        posterImageView.tag = i;
        posterImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectAPoster)];
        [posterImageView addGestureRecognizer:tapGesture];
        
        NSURL *imageURL = [NSURL URLWithString:movieInfo[@"movie"][@"img_url"]];
        [posterImageView sd_setImageWithURL:imageURL
                          placeholderImage:[UIImage imageNamed:@"test2.jpg"]
                                   options:SDWebImageHighPriority | SDWebImageRetryFailed ];
        [movieContentView addSubview:posterImageView];
        
        UILabel *movieRankingNumber = [[UILabel alloc] init];
        movieRankingNumber.frame = CGRectMake(posterImageView.frame.size.width-[self ratioWidth:85], posterImageView.frame.size.height-[self ratioWidth:85], [self ratioWidth:85], [self ratioWidth:85]);
        movieRankingNumber.textColor = [UIColor whiteColor];
        movieRankingNumber.font = [UIFont systemFontOfSize:85 weight:UIFontWeightUltraLight];
        movieRankingNumber.textAlignment = NSTextAlignmentCenter;
        [PCCommonUtility makeTextShadow:movieRankingNumber opacity:0.8];
        [posterImageView addSubview:movieRankingNumber];
        
        
        UIView *movieNumberScoreView = [[UIView alloc] init];
        movieNumberScoreView.frame = CGRectMake([self ratioWidth:10], posterImageView.frame.size.height-[self ratioHeight:85], [self ratioHeight:85], [self ratioHeight:85]);
        [posterImageView addSubview:movieNumberScoreView];
        
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.frame = CGRectMake(0, [self ratioHeight:15], movieNumberScoreView.frame.size.width, [self ratioHeight:20]);
        scoreLabel.text = @"평점";
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.font = [UIFont systemFontOfSize:17];
        [PCCommonUtility makeTextShadow:scoreLabel opacity:0.8];
        [movieNumberScoreView addSubview:scoreLabel];
        
        
        UILabel *scoreNumber = [[UILabel alloc] init];
        scoreNumber.frame = CGRectMake(0, [self ratioHeight:35], movieNumberScoreView.frame.size.width, [self ratioHeight:50]);
        scoreNumber.textColor = [UIColor whiteColor];
        scoreNumber.layer.masksToBounds = NO;
        scoreNumber.layer.shadowOffset = CGSizeMake(0, 1);
        scoreNumber.layer.shadowRadius = 2;
        scoreNumber.layer.shadowOpacity = 0.8;
        scoreNumber.font = [UIFont systemFontOfSize:40 weight:UIFontWeightLight];
        [movieNumberScoreView addSubview:scoreNumber];

        
        UILabel *movieTitle = [[UILabel alloc] init];
        movieTitle.frame = CGRectMake(baseContentMargin*2, [self ratioHeight:399], [self ratioWidth:255], [self ratioHeight:35]);
        movieTitle.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        movieTitle.textAlignment = NSTextAlignmentCenter;
        movieTitle.clipsToBounds = YES;
        movieTitle.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        [movieContentView addSubview:movieTitle];
        
        CALayer *movieTitleBorder = [CALayer layer];
        movieTitleBorder.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
        movieTitleBorder.borderWidth = 1;
        movieTitleBorder.frame = CGRectMake(-1, -1, movieTitle.frame.size.width+2, movieTitle.frame.size.height);
        [movieTitle.layer addSublayer:movieTitleBorder];
        
        
        UIView *movieRankSubView = [[UIView alloc] init];
        movieRankSubView.frame = CGRectMake(baseContentMargin*2, [self ratioHeight:434], [self ratioWidth:255], [self ratioHeight:20]);
        [movieContentView addSubview:movieRankSubView];
        
        UILabel *movieAge = [[UILabel alloc] init];
        movieAge.frame = CGRectMake(0, 0, movieRankSubView.frame.size.width/2-[self ratioWidth:0.5], movieRankSubView.frame.size.height);
        movieAge.textAlignment = NSTextAlignmentCenter;
        movieAge.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        movieAge.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        [movieRankSubView addSubview:movieAge];
        
        
        UIView *movieRankLine = [[UIView alloc] init];
        movieRankLine.frame = CGRectMake(movieRankSubView.frame.size.width/2-[self ratioWidth:0.5], [self ratioHeight:2.5], [self ratioWidth:1], [self ratioHeight:15]);
        movieRankLine.backgroundColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1];
        [movieRankSubView addSubview:movieRankLine];
        
        
        UILabel *movieTicketingPercent = [[UILabel alloc] init];
        movieTicketingPercent.frame = CGRectMake(movieRankSubView.frame.size.width/2+[self ratioWidth:0.5], 0, movieRankSubView.frame.size.width/2+[self ratioWidth:0.5], movieRankSubView.frame.size.height);
        movieTicketingPercent.textAlignment = NSTextAlignmentCenter;
        movieTicketingPercent.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        movieTicketingPercent.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        [movieRankSubView addSubview:movieTicketingPercent];
        
        
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
        starRatingView.frame = CGRectMake([self ratioWidth:55], [self ratioHeight:465], [self ratioWidth:165], [self ratioHeight:25]);
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.allowsHalfStars = YES;
        starRatingView.accurateHalfStars = YES;
        starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
        starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
        starRatingView.userInteractionEnabled = NO;
        [movieContentView addSubview:starRatingView];
        
        // print movie data
        movieRankingNumber.text = [NSString stringWithFormat:@"%@", movieInfo[@"rank"]];
        movieTitle.text = movieInfo[@"movie_title"];
        movieAge.text = movieInfo[@"movie"][@"grade"][@"content"];
        movieTicketingPercent.text = [NSString stringWithFormat:@"예매율 %.2lf%%", [movieInfo[@"ticketing_rate"] floatValue]];
        scoreNumber.text = [NSString stringWithFormat:@"%.1lf", [movieInfo[@"movie"][@"star_average"] floatValue]];
        starRatingView.value = [movieInfo[@"movie"][@"star_average"] floatValue];
    }
}

- (void)didSelectAPoster {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieInfo" bundle:nil];
    PCMovieDetailViewController *movieDetailVC = [storyboard instantiateInitialViewController];
    
    [self.navigationController showViewController:movieDetailVC sender:self];
}

#pragma mark - Configure Magazine View As A Collection View
- (void)requestMagazineList {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
        if (isSuccess)
            [self didReceiveMagazineList:resultArray];
    };
    
    [[PCMovieInfoManager movieManager] requestMagazineListWithCompletionHandler:completionHandler];
}

- (void)didReceiveMagazineList:(NSArray *)magazineList {
    self.magazineList = [NSArray array];
    self.magazineList = magazineList;
    
    [_movieMagazineCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.magazineList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PCMagazineCollectionViewCell *magazineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieMagazineCell" forIndexPath:indexPath];
    
    magazineCell.layer.borderWidth = 1;
    magazineCell.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    
    NSURL *urlString = [NSURL URLWithString:_magazineList[indexPath.row][@"img_url"]];
    [magazineCell.magazineImageView sd_setImageWithURL:urlString placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageCacheMemoryOnly];
    magazineCell.magazineTitleLabel.text = _magazineList[indexPath.row][@"title"];
    
    return magazineCell;
}



#pragma mark - Configure Best Comment View
- (void)requestBestCommentAmongBoxOffice {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
        if (isSuccess)
            [self didReceiveBestComment:resultArray];
    };
    
    [[PCMovieInfoManager movieManager] requestBestCommentWithCompletionHandler:completionHandler];
}

- (void)didReceiveBestComment:(NSArray *)resultArray {
    NSDictionary *bestComment = resultArray[0];
    
    self.bestCommentUsernameLabel.text = [bestComment[@"author"] stringByAppendingString:@" 님의 감상평"];
    self.bestCommentTextView.text = bestComment[@"content"];
    self.bestCommentTextViewHeight.constant = _bestCommentTextView.contentSize.height + 10;
    self.bestCommentBaseViewHeight.constant = 200 - 50 + _bestCommentTextViewHeight.constant;
    
    NSString *movieTitle = [NSString stringWithFormat:@"< %@ > 베스트 감상평", bestComment[@"movie_title"]];
    self.bestCommentMovieTitleLabel.text = movieTitle;
}

- (IBAction)likeBestReviewAction:(UIButton *)sender {
    if (self.likeReview == YES) {
        self.likeHeartView.backgroundColor = [UIColor colorWithRed:255.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1];
        self.likeReview = NO;
    }
    else{
        self.likeHeartView.backgroundColor = [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1];
        self.likeReview = YES;
    }
}

#pragma mark - Configure Today Recommend Movie TableView
- (void)requestTodayRecommendMovie {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray) {
        if (isSuccess)
            [self didReceiveTodayRecommendMovieList:resultArray];
    };
    
    [[PCMovieInfoManager movieManager] requestTodayRecommendMovieWithCompletionHandler:completionHandler];
}

- (void)didReceiveTodayRecommendMovieList:(NSArray *)resultArray {
    self.todayRecommendList = resultArray;
    [self.todayRecommendMovieTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _todayRecommendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCTodayRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendMovieCell"];
    if (cell == nil)
        cell = [[PCTodayRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendMovieCell"];
    
    NSDictionary *movieData = _todayRecommendList[indexPath.row];
    
    [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:movieData[@"img_url"]]];
    [cell.likeButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
//    recommendMovieCell.movieTitleLabel.text = movieData[@"title_kor"];
//    recommendMovieCell.averageRatingLabel.text = [NSString stringWithFormat:@"평균 %@점",  movieData[@"star_average"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 212;
}

- (void)testAction:(UIButton *)button {
    sLog(button);
}


#pragma mark - Ratio
- (CGFloat)ratioWidth:(NSInteger)num{
    return (num * self.view.bounds.size.width) / 375;
}

- (CGFloat)ratioHeight:(NSInteger)num{
    return (num * self.view.bounds.size.height) / 667;
}


- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
