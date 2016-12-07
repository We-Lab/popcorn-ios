//
//  PCHomeViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCHomeViewController.h"

@interface PCHomeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainBoxOfficeView;
@property (weak, nonatomic) IBOutlet UICollectionView *movieMagazineCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *todayRecommendMovieTableView;
@property (weak, nonatomic) IBOutlet UIView *likeHeartView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewControllHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecommendTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecommendViewHeight;

@property (nonatomic) UIScrollView *boxOfficeScrollView;
@property (nonatomic) UIView *movieSlidingContentView;

@property BOOL likeReview;
@property NSArray *testArray;

@end

@implementation PCHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.likeReview = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testArray = @[@"1",@"1",@"1"];

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

#pragma mark - Make Custom View
- (void)setCustomViewStatus{
    [self creatMainBoxOffice];
    
    self.todayRecommendMovieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.todayRecommendTableViewHeight.constant = [self ratioHeight:210] * self.testArray.count;
    
    self.viewControllHeight.constant = 1073 + self.todayRecommendTableViewHeight.constant;
    self.todayRecommendViewHeight.constant = 47 + self.todayRecommendTableViewHeight.constant;
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

#pragma mark - Main Movie Scroll Layout
- (void)creatMovieRankScroll{
    
    for(NSInteger i = 0; i < 12; i++){
        CGFloat baseContentMargin = [self ratioWidth:10];
        CGFloat baseMovieContentWidth = [self ratioWidth:295];
        CGFloat baseMovieContentHeight = [self ratioHeight:507];
        
        UIView *movieContentView = [[UIView alloc] init];
        
        movieContentView.tag = i;
        NSInteger row = movieContentView.tag;
        movieContentView.frame = CGRectMake(baseMovieContentWidth * row,0,
                                            baseMovieContentWidth,baseMovieContentHeight);
        
        [self.movieSlidingContentView addSubview:movieContentView];
        
        UIImageView *moviePosterIMG = [[UIImageView alloc] init];
        moviePosterIMG.frame = CGRectMake(baseContentMargin, 0, [self ratioWidth:275], [self ratioHeight:394]);
        [movieContentView addSubview:moviePosterIMG];
        
        UILabel *movieRankingNumber = [[UILabel alloc] init];
        movieRankingNumber.frame = CGRectMake(moviePosterIMG.frame.size.width-85, moviePosterIMG.frame.size.height-85, 85, 85);
        movieRankingNumber.textColor = [UIColor whiteColor];
        movieRankingNumber.font = [UIFont systemFontOfSize:85 weight:UIFontWeightUltraLight];
        movieRankingNumber.textAlignment = NSTextAlignmentCenter;
        
        [moviePosterIMG addSubview:movieRankingNumber];
        
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
        
        UIView *movieStarScoreView = [[UIView alloc] init];
        movieStarScoreView.frame = CGRectMake(baseContentMargin*2, [self ratioHeight:460], [self ratioWidth:255], [self ratioHeight:25]);
        movieStarScoreView.backgroundColor = [UIColor grayColor];
        
        [movieContentView addSubview:movieStarScoreView];
        
        // 무비랭킹 컨텐츠
        moviePosterIMG.backgroundColor = [UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1];
        movieRankingNumber.text = [NSString stringWithFormat:@"%ld", i];
        movieTitle.text = [NSString stringWithFormat:@"영화제목 %ld", i];
        movieAge.text = [NSString stringWithFormat:@"%ld 관람가", i];
        movieTicketingPercent.text = [NSString stringWithFormat:@"예매율 %ld", i];
    }
}


#pragma mark - Infinite Scroll
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


#pragma mark - CollectionView Required
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.testArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *movieMagazineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieMagazineCell" forIndexPath:indexPath];
    
    movieMagazineCell.layer.borderWidth = 1;
    movieMagazineCell.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    
    return movieMagazineCell;
}

#pragma mark - Best Review Button Action
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

#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *recommendMovieCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendMovieCell" forIndexPath:indexPath];
    
    if (recommendMovieCell != nil) {
        recommendMovieCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendMovieCell"];
    }
    
    return recommendMovieCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

#pragma mark - Custom Method
- (CGFloat)ratioWidth:(NSInteger)num{
//    return (num * self.view.frame.size.width) / [[UIScreen mainScreen] bounds].size.width;
    return (num * self.view.frame.size.width) / 375;
}

- (CGFloat)ratioHeight:(NSInteger)num{
//    return (num * self.view.frame.size.height) / [[UIScreen mainScreen] bounds].size.height;
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
