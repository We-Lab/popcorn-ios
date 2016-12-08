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

@interface PCMovieDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *movieMainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UIView *starScoreView;

@property (weak, nonatomic) IBOutlet UIView *moviePosterView;
@property (weak, nonatomic) IBOutlet UITextView *movieStoryTextView;

@property (weak, nonatomic) IBOutlet UIView *movieInfoButtonView;

@property (weak, nonatomic) IBOutlet UITableView *movieVideoTableView;

@property (weak, nonatomic) IBOutlet UIButton *movieStoryMoreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieStoryLayerHeight;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *famousLineTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *famousLineTableViewHeight;

@property (weak, nonatomic) IBOutlet UIView *commentContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContentHeight;
@property (weak, nonatomic) IBOutlet UIView *famousLineContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *famousLineContentHeight;
@property BOOL test;

@end

@implementation PCMovieDetailViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.test = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self setCustomViewStatus];
    [self setCustomMovieCommentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

#pragma mark - Make Custom Navi View
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 200) {
        
        self.test = NO;
        
        [self preferredStatusBarStyle];
    }
}


- (void)makeNavigationView {
    // 커스텀 네비게이션바 생성
    PCMovieNaviView *viewNavi = [[PCMovieNaviView alloc] initWithType:MovieNaviBarTypeDetailView ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    sLog([viewNavi class]);
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.test == YES) {
        return UIStatusBarStyleLightContent;
    }
    
    return UIStatusBarStyleDefault;
}

// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{

    self.moviePosterView.layer.masksToBounds = NO;
    self.moviePosterView.layer.shadowOffset = CGSizeMake(0, 1);
    self.moviePosterView.layer.shadowRadius = 2;
    self.moviePosterView.layer.shadowOpacity = 0.3;
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(0, 0, self.starScoreView.frame.size.width, self.starScoreView.frame.size.height);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 3.5;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRatingView.halfStarImage = [UIImage imageNamed:@"HalfStar"]; // optional
    starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
    [self.starScoreView addSubview:starRatingView];
    
    self.movieInfoButtonView.layer.borderWidth = 1;
    self.movieInfoButtonView.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    
    [self.movieStoryMoreButton setTitle:@"더보기" forState:UIControlStateNormal];
    
    self.movieVideoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - Custom Comment View
- (void)setCustomMovieCommentView{

//    for (NSInteger i = 0; i < 3; i += 1) {
//        
//    }
    
    UIView *userWriteContentView = [[UIView alloc] init];
    
    userWriteContentView.frame = CGRectMake(0, 0, self.commentContentView.frame.size.width, self.commentContentView.frame.size.height);
    
    [self.commentContentView addSubview:userWriteContentView];
    
    UIImageView *userImage = [[UIImageView alloc] init];
    
    userImage.frame = CGRectMake(0, 0, [self ratioWidth:40], [self ratioHeight:40]);
    userImage.backgroundColor = [UIColor redColor];
    userImage.layer.cornerRadius = 20;
    
    [userWriteContentView addSubview:userImage];
    
    UIView *commentContent = [[UIView alloc] init];
    
    commentContent.frame = CGRectMake([self ratioWidth:55], [self ratioHeight:5], userWriteContentView.frame.size.width - [self ratioWidth:55], userWriteContentView.frame.size.height - [self ratioHeight:5]);
    
    [userWriteContentView addSubview:commentContent];
    
    UILabel *commentUserID = [[UILabel alloc] init];
    
    commentUserID.frame = CGRectMake(0, 0, commentContent.frame.size.width, [self ratioHeight:15]);
    commentUserID.text = @"유저 아이디";
    commentUserID.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    
    [commentContent addSubview:commentUserID];
    
    
    
    UITextView *commentContentText = [[UITextView alloc] init];
    
    CGRect textViewFrame = commentContentText.frame;
    textViewFrame.size.height = commentContentText.contentSize.height;
    
//    NSLog(@"야야야 -%lf", textViewFrame.size.height);
    
    commentContentText.frame = CGRectMake(0, [self ratioHeight:15], commentContent.frame.size.width, textViewFrame.size.height);
    commentContentText.text = @"asdfasdfasdfasdfasdfasdfasdfasdfasfdasfdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasfdasfdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasfdasfdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasfdasfdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasfdasfdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
    
    [commentUserID addSubview:commentContentText];
    
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
