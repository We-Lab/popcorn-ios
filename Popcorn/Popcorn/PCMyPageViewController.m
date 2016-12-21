//
//  PCMyPageViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMyPageViewController.h"

#import <HCSStarRatingView.h>
#import <UIImageView+WebCache.h>

#import "PCUserProfileParamKey.h"
#import "PCUserInformation.h"
#import "PCUserInfoManager.h"

#import "PCMyPageLikeTableViewCell.h"
#import "PCMyPageCommentTableViewCell.h"
#import "PCMyPageFamousTableViewCell.h"

@interface PCMyPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myPageMainTableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

@property (weak, nonatomic) IBOutlet UILabel *myPageUserID;

@property (nonatomic) UIButton *myPageButton;
@property (nonatomic) NSInteger selectButton;
@property (nonatomic) UIView *buttonUnderLine;

@property (nonatomic) NSArray *myCommentList;
@property (nonatomic) NSArray *myFamousList;
@property (nonatomic) NSArray *myLikeList;

@end

@implementation PCMyPageViewController

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectButton = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myPageMainTableView.rowHeight = UITableViewAutomaticDimension;
    self.myPageMainTableView.estimatedRowHeight = 150;
    self.userProfileImageView.image = [[PCUserInformation sharedUserData] getUserProfileImage];
    self.myPageUserID.text = [[PCUserInformation sharedUserData].userInformation objectForKey:PCUserProfileNickNameKey];
    [self makeTableViewHeader];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestUserInteractionData];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)requestUserInteractionData {
    [[PCUserInfoManager userInfoManager] requestUserCommentListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:0];
        else
            alertLog(@"코멘트 정보를 가져오는 데 실패하였습니다.");
    }];
    [[PCUserInfoManager userInfoManager] requestUserFamousListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:1];
        else
            alertLog(@"명대사 정보를 가져오는 데 실패하였습니다.");
    }];
    [[PCUserInfoManager userInfoManager] requestUserLikeMovieListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:2];
        else
            alertLog(@"좋아요 정보를 가져오는 데 실패하였습니다.");
    }];
}

- (void)didReceiveUserInteractionData:(NSDictionary *)userData andIndex:(NSUInteger)index {
    if (index == 0) {
        self.myCommentList = userData[@"results"];
    }
    else if (index == 1) {
        self.myFamousList = userData[@"results"];
    }
    else if (index == 2) {
        self.myLikeList = userData[@"results"];
    }
    
    [self.myPageMainTableView reloadData];
}


#pragma mark - Make TableView Header
- (void)makeTableViewHeader{
    
    CGFloat baseMovieContentWidth = self.view.frame.size.width/3;
    CGFloat baseMovieContentHeight = [self ratioHeight:42];
    
    self.buttonUnderLine = [[UIView alloc] init];
    self.buttonUnderLine.frame = CGRectMake(0, baseMovieContentHeight, baseMovieContentWidth, [self ratioHeight:3]);
    self.buttonUnderLine.backgroundColor = [UIColor darkGrayColor];
    [self.tableViewHeaderButtonView addSubview:self.buttonUnderLine];
    
    [PCCommonUtility makeTextShadow:self.myPageUserID opacity:0.8];
}

#pragma mark - TableView Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count;
    if (self.selectButton == 0) {
         count = _myCommentList.count;
    }
    else if (self.selectButton == 1) {
        count = _myFamousList.count;
    }
    else {
        count = _myLikeList.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *textCell = @[@"MyCommentCell", @"MyFamousLineCell", @"MyLikeMovieCell"];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell[self.selectButton] forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell[self.selectButton]];
//    }

    if (self.selectButton == 0) {
        PCMyPageCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell" forIndexPath:indexPath];
        
        cell.myCommentTitle.text = _myCommentList[indexPath.row][@"movie_title"];
        cell.myCommentText.text = _myCommentList[indexPath.row][@"content"];
        cell.myCommentLikeText.text = [NSString stringWithFormat:@"%@명이 좋아합니다.", _myCommentList[indexPath.row][@"likes_count"]];
        NSString *commentDate =[_myCommentList[indexPath.row][@"created"] substringWithRange:NSMakeRange(0, 10)];
        cell.myCommentDate.text = commentDate;
        
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
        starRatingView.frame = CGRectMake(0, 0, 120, cell.myCommentStarScoreView.frame.size.height);
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.backgroundColor = [UIColor clearColor];
        starRatingView.allowsHalfStars = YES;
        starRatingView.accurateHalfStars = YES;
        starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
        starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
        starRatingView.userInteractionEnabled = NO;
        
        starRatingView.value = [_myCommentList[indexPath.row][@"star"] floatValue];
        [cell.myCommentStarScoreView addSubview:starRatingView];
        
        return cell;
    }
    else if (self.selectButton == 1){
    
        PCMyPageFamousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFamousLineCell" forIndexPath:indexPath];
        
        [cell.myFamousActorImage sd_setImageWithURL:_myFamousList[indexPath.row][@"actor_img_url"]];
        cell.myFamousMovieTitle.text = _myFamousList[indexPath.row][@"movie_title"];
        cell.myFamousActorName.text = [NSString stringWithFormat:@"%@ | %@",_myFamousList[indexPath.row][@"actor_kor_name"],_myFamousList[indexPath.row][@"actor_character_name"]];
        cell.myFamousText.text = _myFamousList[indexPath.row][@"content"];
        cell.myFamousLikeText.text = [NSString stringWithFormat:@"%@명이 좋아합니다.",_myFamousList[indexPath.row][@"likes_count"]];
        
        NSString *commentDate =[_myFamousList[indexPath.row][@"created"] substringWithRange:NSMakeRange(0, 10)];
        cell.myFamousDate.text = commentDate;
        
        return cell;
    }
    else if (self.selectButton == 2){
        PCMyPageLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLikeMovieCell" forIndexPath:indexPath];
        
        [cell.myLikeMoviePoster sd_setImageWithURL:_myLikeList[indexPath.row][@"movie"][@"img_url"]];
        cell.myLikeMovieTitle.text = _myLikeList[indexPath.row][@"movie"][@"title_kor"];
        cell.myLikeMovieInfo.text = [NSString stringWithFormat:@"%@",_myLikeList[indexPath.row][@"movie"][@"created_year"]];
        cell.myLikeMovieGrade.text = _myLikeList[indexPath.row][@"movie"][@"grade"][@"content"];
        
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
        starRatingView.frame = CGRectMake(0, 0, 120, cell.myLikeMovieStarView.frame.size.height);
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.backgroundColor = [UIColor clearColor];
        starRatingView.allowsHalfStars = YES;
        starRatingView.accurateHalfStars = YES;
        starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
        starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
        starRatingView.userInteractionEnabled = NO;
        
        starRatingView.value = [_myLikeList[indexPath.row][@"movie"][@"star_average"] floatValue];
        [cell.myLikeMovieStarView addSubview:starRatingView];
        
        return cell;
    }
    
    return nil;
}


- (IBAction)reloadSection:(UIButton *)sender {
    if (self.selectButton != sender.tag) {
        if (self.selectButton > sender.tag) {
            self.selectButton = sender.tag;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.view.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.view.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            
        }
        else if (self.selectButton < sender.tag) {
            self.selectButton = sender.tag;
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.view.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.view.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
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
